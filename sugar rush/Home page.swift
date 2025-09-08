//
//  Home page.swift
//  sugar rush
//
//  Created by Julia Li on 16/8/25.
//

import SwiftUI

class GameData: ObservableObject {
    @Published var score: Int = 0
    @Published var hasExploded: Bool = false
    
    func checkForExplosion() {
        if score >= 5040 && !hasExploded {
            hasExploded = true
        }
    }
}

struct ExplosionView: View {
    @State private var particles: [Particle] = []
    @State private var animationTimer: Timer?
    
    struct Particle {
        var x: CGFloat
        var y: CGFloat
        var velocityX: CGFloat
        var velocityY: CGFloat
        var color: Color
        var opacity: Double = 1.0
        var scale: CGFloat = 1.0
    }
    
    var body: some View {
        ZStack {
            ForEach(0..<particles.count, id: \.self) { index in
                Circle()
                    .fill(particles[index].color)
                    .frame(width: 8, height: 8)
                    .scaleEffect(particles[index].scale)
                    .opacity(particles[index].opacity)
                    .position(x: particles[index].x, y: particles[index].y)
            }
        }
        .onAppear {
            createExplosion()
        }
    }
    
    func createExplosion() {
        let colors: [Color] = [.red, .orange, .yellow, .pink, .purple, .blue]
        
        for _ in 0..<50 {
            let particle = Particle(
                x: 200,
                y: 200,
                velocityX: CGFloat.random(in: -200...200),
                velocityY: CGFloat.random(in: -200...200),
                color: colors.randomElement() ?? .red
            )
            particles.append(particle)
        }
        
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
            updateParticles()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            animationTimer?.invalidate()
        }
    }
    
    func updateParticles() {
        for i in 0..<particles.count {
            particles[i].x += particles[i].velocityX * 0.02
            particles[i].y += particles[i].velocityY * 0.02
            particles[i].velocityY += 200 * 0.02 // gravity
            particles[i].opacity -= 0.01
            particles[i].scale *= 0.99
        }
    }
}

struct Home_page: View {
    @EnvironmentObject var gameData: GameData
    @State var showTutorial = false
    @State private var showExplosion = false
    @State private var kmyScale: CGFloat = 1.0
    @State private var kmyRotation: Double = 0
    @State private var kmyOpacity: Double = 1.0
    
    var body: some View {
        NavigationStack {
            VStack {
                
                HStack {
                    Spacer()
                    Button {
                        showTutorial = true
                    } label: {
                        Text("tutorial")
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Spacer()
                    
                    NavigationLink {
                        Minigames_()
                            .environmentObject(gameData)
                    } label: {
                        HStack {
                            Spacer()
                            Text("Minigames")
                            Spacer()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Spacer()
                }
                
                Image("kmyyay")
                    .resizable()
                    .frame(width: 300, height: 300)
                    .position(x: 200, y: 130)
                
                Text("Amount of Sugar")
                    .font(.title2)
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.teal)
                    )
                    .foregroundColor(.white)
                    .position(x: 300, y: 120)

                
                Spacer()
                
                ZStack {
                    HStack {
                        Image("kmy")
                            .resizable()
                            .frame(width: 300, height: 500)
                            .scaleEffect(kmyScale)
                            .rotationEffect(.degrees(kmyRotation))
                            .opacity(kmyOpacity)
                            .animation(.easeInOut(duration: 0.5), value: kmyScale)
                            .animation(.easeInOut(duration: 0.3), value: kmyRotation)
                            .animation(.easeInOut(duration: 0.3), value: kmyOpacity)
                        
                        Spacer()
                        
                        VStack {
                            Image("jar")
                                .resizable()
                                .frame(width: 200, height: 300)
                            
                            Text("Score: \(gameData.score)g")
                                .font(.title)
                                .foregroundColor(gameData.score >= 5040 ? .red : .black)
                                .fontWeight(gameData.score >= 5040 ? .bold : .regular)
                                .padding(.top, 10)
                        }
                    }
                    .padding(.horizontal)
                    
                    if showExplosion {
                        ExplosionView()
                            .frame(width: 400, height: 400)
                    }
                    
                    if showExplosion {
                        ConfettiView()
                            .frame(width: 400, height: 600)
                    }
                    
                    if gameData.hasExploded && showExplosion {
                        VStack {
                            Text("yay u exploded kmy")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                                .shadow(color: .black, radius: 2)
                            
                            Text("she ate at least 5040g of sugar")
                                .font(.title2)
                                .foregroundColor(.orange)
                                .fontWeight(.semibold)
                            
                            Text("A new Kmy appears...")
                                .font(.title3)
                                .foregroundColor(.green)
                                .fontWeight(.medium)
                                .padding(.top, 10)
                        }
                        .position(x: 200, y: 200)
                        .zIndex(10)
                    }
                }
                
                Spacer()
            }
            .background(Color.purple.opacity(0.2))
            .navigationTitle(Text("Sugar Rush"))
            .sheet(isPresented: $showTutorial) {
                tutorialview()
            }
            .onChange(of: gameData.score) {
                gameData.checkForExplosion()
                
                if gameData.hasExploded && !showExplosion {
                    triggerExplosion()
                }
            }
        }
    }
    
    private func triggerExplosion() {

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            showExplosion = true

            withAnimation(.easeInOut(duration: 0.2)) {
                kmyScale = 1.5
                kmyRotation = 360
            }
            

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    kmyScale = 0.1
                    kmyOpacity = 0
                }
            }
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                showExplosion = false
                

                gameData.score = 0
                gameData.hasExploded = false
                

                kmyScale = 1.0
                kmyRotation = 0
                kmyOpacity = 1.0
                

                withAnimation(.easeInOut(duration: 0.5)) {
                    kmyScale = 1.0
                }
            }
        }
    }
}



#Preview {
    Home_page()
        .environmentObject(GameData())
}
