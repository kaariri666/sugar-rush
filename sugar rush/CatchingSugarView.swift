//
//  catchingSugar.swift
//  sugar rush
//
//  Created by Julia Li on 16/8/25.
//

import SwiftUI

struct CatchingSugarView: View {
    @EnvironmentObject var gameData: GameData
    @State var timeLeft = 120
    @State var gameOver = false
    @State var basketX = 200.0
    @State var sugars: [Sugar] = []
    @State var movingDirection = ""
    @State var moveTimer: Timer?

    var body: some View {
        if gameOver {
            VStack {
                Text("TIMES UP")
                    .font(.largeTitle)
                    .padding()
                
                Text("GO TOUCH SOME GRASS")
                    .font(.largeTitle)
                    .padding()
                
                Text("ur score was \(gameData.score)g")
                    .font(.title2)
                    .padding()
                
                Text("game over sucker")
                    .font(.title3)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.pink.opacity(0.3))
        } else {
            ZStack {
                Color.pink.opacity(0.3)
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Text("SCORE: \(gameData.score)g")
                            .font(.headline)
                        Spacer()
                        Text("Timer: \(timeLeft)s")
                            .font(.headline)
                    }
                    .padding()
                    
                    Spacer()
                    
                    ZStack {
                        ForEach(sugars) { sugar in
                            Image(sugar.imageName)
                                .resizable()
                                .frame(width: 75, height: 75)
                                .position(x: sugar.x, y: sugar.y)
                        }
                        
                        Image("basket")
                            .resizable()
                            .frame(width: 80, height: 60)
                            .position(x: basketX, y: 650)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    HStack {
                        Button("←") {
                        }
                        .font(.title)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
                            if pressing {
                                startMoving(direction: "left")
                            } else {
                                stopMoving()
                            }
                        }, perform: {})
                        
                        Spacer()
                        
                        Button("→") {
                        }
                        .font(.title)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
                            if pressing {
                                startMoving(direction: "right")
                            } else {
                                stopMoving()
                            }
                        }, perform: {})
                    }
                    .padding()
                }
            }
            .onAppear {
                startGame()
            }
        }
    }
    
    func startGame() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if timeLeft > 0 {
                timeLeft -= 1
            } else {
                gameOver = true
                timer.invalidate()
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { timer in
            if !gameOver {
                spawnSugar()
            } else {
                timer.invalidate()
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if !gameOver {
                moveSugars()
                checkCollisions()
            } else {
                timer.invalidate()
            }
        }
    }
    
    func spawnSugar() {
        let randomX = Double.random(in: 40...360)
        let randomChance = Double.random(in: 0...1)
        
        let itemType: String
        let imageName: String
        let points: Int
        
        if randomChance < 0.02 {
            itemType = "fu"
            imageName = "fu"
            points = -500
        } else if randomChance < 0.15 {
            itemType = "ant"
            imageName = "ant"
            points = -100
        } else if randomChance < 0.20 {
            itemType = "brown"
            imageName = "brown sugar"
            points = 100
        } else {
            itemType = "normal"
            imageName = "sugar"
            points = 50
        }
        
        let newSugar = Sugar(
            x: randomX,
            y: 0,
            type: itemType,
            imageName: imageName,
            points: points
        )
        
        sugars.append(newSugar)
    }
    
    func moveSugars() {
        for i in 0..<sugars.count {
            sugars[i].y += 50
        }
        
        let missedSugars = sugars.filter { $0.y >= 700 }
        for _ in missedSugars {
            gameData.score = max(0, gameData.score - 10)
        }
        
        sugars = sugars.filter { $0.y < 700 }
    }
    
    func checkCollisions() {
        for sugar in sugars {
            if sugar.y > 600 && sugar.y < 680 {
                if sugar.x > basketX - 40 && sugar.x < basketX + 40 {
                    gameData.score += sugar.points
                    if let index = sugars.firstIndex(where: { $0.id == sugar.id }) {
                        sugars.remove(at: index)
                    }
                }
            }
        }
    }
    
    func moveBasket(direction: String) {
        if direction == "left" {
            basketX = max(40, basketX - 30)
        } else {
            basketX = min(360, basketX + 30)
        }
    }
    
    func startMoving(direction: String) {
        movingDirection = direction
        moveTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            if movingDirection == "left" {
                basketX = max(40, basketX - 8)
            } else {
                basketX = min(360, basketX + 8)
            }
        }
    }
    
    func stopMoving() {
        moveTimer?.invalidate()
        moveTimer = nil
        movingDirection = ""
    }
}

struct Sugar: Identifiable {
    let id = UUID()
    var x: Double
    var y: Double
    let type: String
    let imageName: String
    let points: Int
}

#Preview {
    CatchingSugarView()
}
