//
//  shootingSugar.swift
//  sugar rush
//
//  Created by Julia Li on 16/8/25.
//

import SwiftUI

private enum SugarType: CaseIterable {
    case normal
    case special
    case rare
    
    var points: Int {
        switch self {
        case .normal: return 50
        case .special: return 75
        case .rare: return 100
        }
    }
}

private struct SugarTarget: Identifiable {
    let id = UUID()
    var position: CGPoint
    var speed: CGFloat
    let type: SugarType
    let scoop: Scoop
}

private struct Bullet: Identifiable {
    let id = UUID()
    var position: CGPoint
    var speed: CGFloat
}

struct ShootingSugar: View {
    @EnvironmentObject var gameData: GameData
    @Environment(\.dismiss) private var dismiss
    
    @State private var isGameActive: Bool = false
    @State private var timeRemaining: Int = 50
    @State private var gameScore: Int = 0
    @State private var showGameOver: Bool = false
    
    @State private var gunX: CGFloat = 200
    @State private var targets: [SugarTarget] = []
    @State private var bullets: [Bullet] = []
    
    @State private var secondTimer: Timer?
    @State private var tickTimer: Timer?
    @State private var spawnTimer: Timer?
    
    private let playAreaHeight: CGFloat = 420
    private let playAreaWidth: CGFloat = 400
    private let gunBarrelSize: CGSize = .init(width: 8, height: 34)
    private let gunBaseSize: CGSize = .init(width: 90, height: 28)
    private let bulletSize: CGSize = .init(width: 10, height: 18)
    private let targetSize: CGFloat = 36
    
    var body: some View {
        NavigationView {
            VStack {
                header
                playArea
                controls
            }
            .navigationBarHidden(true)
            .background(Color(red: 0.7, green: 0.9, blue: 0.7))
            .overlay(gameOverOverlay)
        }
    }
}

private extension ShootingSugar {
    var header: some View {
        VStack {
            HStack {
                Button(action: { dismiss() }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(.blue)
                }
                .padding(.leading)
                Spacer()
            }
            .padding(.top)
            
            HStack {
                Text("Score: \(gameScore)")
                Spacer()
                Text("Time: \(timeRemaining)s")
                    .foregroundColor(timeRemaining <= 10 ? .red : .primary)
            }
            .padding()
        }
    }
    
    var playArea: some View {
        ZStack {
            Rectangle()
                .fill(Color.gray.opacity(0.1))
                .frame(height: playAreaHeight)
                .cornerRadius(10)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            gunX = min(max(gunEdgePadding, value.location.x), playAreaWidth - gunEdgePadding)
                        }
                )
            
            ForEach(targets) { target in
                ScoopView(scoop: target.scoop)
                    .frame(width: targetSize, height: targetSize)
                    .position(target.position)
            }
            
            ForEach(bullets) { bullet in
                Circle()
                    .fill(Color.blue)
                    .frame(width: bulletSize.width, height: bulletSize.height)
                    .position(bullet.position)
            }
            
            VStack(spacing: 6) {
                Rectangle()
                    .fill(Color.black)
                    .frame(width: gunBarrelSize.width, height: gunBarrelSize.height)
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.black)
                    .frame(width: gunBaseSize.width, height: gunBaseSize.height)
            }
            .position(x: gunX, y: playAreaHeight - 16)
            .onTapGesture { shoot() }
            .accessibilityLabel("Gun")
        }
        .padding(.bottom)
    }
    
    var controls: some View {
        Group {
            if !isGameActive {
                Button(action: startGame) {
                    HStack {
                        Image(systemName: "play.circle.fill")
                        Text("Start Game!")
                    }
                    .font(.title2)
                    .padding()
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.orange, Color.red]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .foregroundColor(.white)
                    .cornerRadius(15)
                }
            }
        }
        .padding(.bottom)
    }
    
    @ViewBuilder
    var gameOverOverlay: some View {
        Group {
            if showGameOver {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .overlay(
                        VStack(spacing: 10) {
                            Text("🎉 Game Over!")
                                .font(.title)
                                .fontWeight(.bold)
                            Text("Game Score: \(gameScore)")
                                .font(.title2)
                            Text("Total Score: \(gameData.score)")
                                .font(.title2)
                                .foregroundColor(.blue)
                            Button("Continue") { showGameOver = false }
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                    )
            }
        }
    }
}

private extension ShootingSugar {
    var gunEdgePadding: CGFloat { max(gunBaseSize.width * 0.5, 30) }
    
    func startGame() {
        isGameActive = true
        timeRemaining = 50
        gameScore = 0
        targets.removeAll()
        bullets.removeAll()
        gunX = playAreaWidth / 2
        
        secondTimer?.invalidate(); tickTimer?.invalidate(); spawnTimer?.invalidate()
        
        secondTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            timeRemaining -= 1
            if timeRemaining <= 0 { endGame() }
        }
        tickTimer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in updatePositions() }
        spawnTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in if targets.count < 3 { spawnTarget() } }
    }
    
    func endGame() {
        isGameActive = false
        secondTimer?.invalidate(); secondTimer = nil
        tickTimer?.invalidate(); tickTimer = nil
        spawnTimer?.invalidate(); spawnTimer = nil
        gameData.score += gameScore
        showGameOver = true
    }
    
    func spawnTarget() {
        let type = SugarType.allCases.randomElement() ?? .normal
        let x = CGFloat.random(in: targetSize...(playAreaWidth - targetSize))
        let speed = CGFloat.random(in: 1.6...2.6)
        targets.append(SugarTarget(position: CGPoint(x: x, y: 0), speed: speed, type: type, scoop: Scoop.random()))
    }
    
    func shoot() {
        guard isGameActive else { return }
        bullets.append(Bullet(position: CGPoint(x: gunX, y: playAreaHeight - 40), speed: 8.0))
    }
    
    func updatePositions() {
        for i in targets.indices { targets[i].position.y += targets[i].speed }
        for i in bullets.indices { bullets[i].position.y -= bullets[i].speed }
        bullets.removeAll { $0.position.y < -10 }
        
        var rmB: Set<UUID> = []
        var rmT: Set<UUID> = []
        for b in bullets {
            for t in targets {
                let dx = b.position.x - t.position.x
                let dy = b.position.y - t.position.y
                if sqrt(dx*dx + dy*dy) < 36 || (abs(dx) < 24 && abs(dy) < 24) {
                    rmB.insert(b.id); rmT.insert(t.id); gameScore += t.type.points
                }
            }
        }
        bullets.removeAll { rmB.contains($0.id) }
        targets.removeAll { rmT.contains($0.id) }
        
        let bottom = playAreaHeight - 5
        var missed: [UUID] = []
        for t in targets { if t.position.y >= bottom { gameScore -= t.type.points; missed.append(t.id) } }
        targets.removeAll { missed.contains($0.id) }
    }
}

#Preview {
    ShootingSugar()
        .environmentObject(GameData())
}
