//
//  CollectingSugarView.swift
//  sugar rush
//
//  Created by Dilan Subhu Veerappan on 13/6/25.
//

import SwiftUI

struct SugarBall: Identifiable {
    let id = UUID()
    var position: CGPoint
    let type: SugarType
    var isMoving = false
    let scoop: Scoop
    
    enum SugarType: CaseIterable {
        case normal, special, rare
        
        var color: Color {
            switch self {
            case .normal: return .yellow
            case .special: return .pink
            case .rare: return .purple
            }
        }
        
        var points: Int {
            switch self {
            case .normal: return 50
            case .special: return 75
            case .rare: return 100
            }
        }
    }
}

struct CollectingSugarView: View {
    @EnvironmentObject var gameData: GameData
    @Environment(\.dismiss) private var dismiss
    @State private var timeRemaining = 50
    @State private var gameTimer: Timer?
    @State private var isGameActive = false
    @State private var gameScore = 0
    @State private var showGameOver = false
    @State private var drawnPath: [CGPoint] = []
    @State private var sugarBalls: [SugarBall] = []
    @State private var isDrawing = false
    @State private var showScoreFeedback = false
    @State private var scoreFeedbackText = ""
    @State private var scoreFeedbackColor = Color.green
    @State private var selectedSugar: SugarBall?
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button(action: { dismiss() }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }.foregroundColor(.blue)
                    }
                    .padding(.leading)
                    
                    Spacer()
                }
                .padding(.top)
                
                HStack {
                    Text("Score: \(gameScore)")
                    Spacer()
                    Text("Time: \(timeRemaining)s").foregroundColor(timeRemaining <= 10 ? .red : .primary)
                }.padding()
                
                ZStack {
                    Canvas { context, size in
                        if drawnPath.count > 1 {
                            var path = Path()
                            path.move(to: drawnPath[0])
                            for point in drawnPath.dropFirst() { path.addLine(to: point) }
                            context.stroke(path, with: .color(.blue), lineWidth: 4)
                        }
                    }
                    .frame(height: 400)
                    .background(Color.gray.opacity(0.1))
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                if isGameActive && !hasMovingSugar() {
                                    if !isDrawing { drawnPath = []; isDrawing = true }
                                    drawnPath.append(value.location)
                                }
                            }
                            .onEnded { _ in
                                isDrawing = false
                                if !drawnPath.isEmpty && !hasMovingSugar() { moveSugar() }
                            }
                    )
                    
                    ForEach(sugarBalls) { sugarBall in
                        ScoopView(scoop: sugarBall.scoop)
                            .frame(width: 40, height: 40)
                            .position(sugarBall.position)
                            .onTapGesture { selectedSugar = sugarBall }
                    }
                    
                    Image("basket")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .position(x: 200, y: 380)
                }
                
                HStack(spacing: 20) {
                    Button(action: { isGameActive ? spawnNewSugar() : startGame() }) {
                        HStack {
                            Image(systemName: isGameActive ? "plus.circle.fill" : "play.circle.fill")
                            Text(isGameActive ? "New Sugar" : "Start Game!")
                        }
                        .font(.title2)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: isGameActive ? [Color.green, Color.blue] : [Color.orange, Color.red]), startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                    }
                    .disabled(timeRemaining == 0)
                    
                    if isGameActive {
                        Button(action: { drawnPath = [] }) {
                            HStack {
                                Image(systemName: "trash.circle.fill")
                                Text("Clear Path")
                            }
                            .font(.title2)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .shadow(radius: 5)
                        }
                    }
                }
                .padding(.bottom)
            }
            .navigationBarHidden(true)
            .background(Color(red: 0.6, green: 0.75, blue: 0.85).ignoresSafeArea())
            .overlay(
                Group {
                    if showGameOver {
                        Color.black.opacity(0.4)
                            .overlay(
                                VStack {
                                    Text("🎉 Game Over!")
                                        .font(.title)
                                        .fontWeight(.bold)
                                    Text("Game Score: \(gameScore)")
                                        .font(.title2)
                                    Text("Total Score: \(gameData.score)")
                                        .font(.title2)
                                        .foregroundColor(.blue)
                                    Button("Continue") { showGameOver = false; dismiss() }
                                        .padding()
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(15)
                                .shadow(radius: 10)
                            )
                    }
                    
                    if showScoreFeedback {
                        VStack {
                            Text(scoreFeedbackText)
                                .font(.title)
                                .foregroundColor(scoreFeedbackColor)
                            Text("Total: \(gameData.score)")
                                .font(.headline)
                                .foregroundColor(.blue)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    }
                    
                    if let sugar = selectedSugar {
                        Color.black.opacity(0.4)
                            .overlay(
                                VStack {
                                    Text("Sugar Type: \(sugar.type)")
                                    Text("Points: \(sugar.type.points)")
                                    Button("Close") { selectedSugar = nil }
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                            )
                    }
                }
            )
        }
    }
    
    func startGame() {
        isGameActive = true
        timeRemaining = 50
        gameScore = 0
        sugarBalls = []
        spawnNewSugar()
        
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            timeRemaining -= 1
            if timeRemaining <= 0 { endGame() }
        }
    }
    
    func spawnNewSugar() {
        let type = SugarBall.SugarType.allCases.randomElement() ?? .normal
        sugarBalls.append(SugarBall(
            position: CGPoint(x: CGFloat.random(in: 50...350), y: 80),
            type: type,
            scoop: Scoop.random()
        ))
    }
    
    func hasMovingSugar() -> Bool {
        return sugarBalls.contains { $0.isMoving }
    }
    
    func moveSugar() {
        guard let index = sugarBalls.firstIndex(where: { !$0.isMoving }) else { return }
        sugarBalls[index].isMoving = true
        
        for (i, point) in drawnPath.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.02) {
                withAnimation(.easeInOut(duration: 0.02)) {
                    if index < sugarBalls.count { sugarBalls[index].position = point }
                }
                if i == drawnPath.count - 1 { checkCollision(index) }
            }
        }
    }
    
    func checkCollision(_ index: Int) {
        let distance = sqrt(pow(sugarBalls[index].position.x - 200, 2) + pow(sugarBalls[index].position.y - 380, 2))
        let points = distance < 60 ? sugarBalls[index].type.points : -25
        gameScore += points
        showScoreFeedback(points > 0 ? "+\(points)" : "\(points)", color: points > 0 ? .green : .red)
        
        sugarBalls.remove(at: index)
        drawnPath = []
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { spawnNewSugar() }
    }
    
    func showScoreFeedback(_ text: String, color: Color) {
        scoreFeedbackText = text
        scoreFeedbackColor = color
        showScoreFeedback = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { showScoreFeedback = false }
    }
    
    func endGame() {
        gameTimer?.invalidate()
        isGameActive = false
        gameData.score += gameScore
        showGameOver = true
    }
}

#Preview {
    CollectingSugarView()
        .environmentObject(GameData())
}
