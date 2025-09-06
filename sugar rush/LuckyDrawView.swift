//
//  luckyDraw.swift
//  sugar rush
//
//  Created by Julia Li on 16/8/25.
//

import SwiftUI

struct LuckyDrawView: View {
    @EnvironmentObject var gameData: GameData
    @Environment(\.dismiss) private var dismiss
    @State var rotation = 0.0
    @State var isSpinning = false
    @State var winner = ""
    @State private var showPopup = false

    let prizes = ["nothing", "nothing", "nothing", "sugar"]
    let colors = [Color.pink, Color.purple, Color.teal, Color.orange]

    var body: some View {
        
        VStack {
            
            // Back button at top left
            HStack {
                Button(action: {
                    dismiss()
                }) {
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
            
            Text("spin it")
                .font(.title)
                .padding()

            ZStack {
                ForEach(0..<4) { i in
                    PieSlice(startAngle: Double(i) * 90, endAngle: Double(i + 1) * 90)
                        .fill(colors[i])
                    
                    Text(prizes[i])
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                        .offset(y: -115)
                        .rotationEffect(.degrees(Double(i) * 90 + 45))
                }
            }
            .frame(width: 380, height: 380)
            .rotationEffect(.degrees(rotation))
            .animation(.easeOut(duration: 3), value: rotation)
            
            Triangle()
                .fill(Color.black)
                .frame(width: 30, height: 25)
                .offset(y: -275)

            Button("SPIN") {
                spin()
            }
            .font(.title)
            .padding()
            .frame(width: 120, height: 120)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(70)
            .disabled(isSpinning)
            .offset(x: 0, y: -285)
        }
        .padding()
        .overlay(

            Group {
                if showPopup {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            showPopup = false
                        }
                    
                    VStack(spacing: 20) {
                        Text("yay")
                            .font(.system(size: 60))
                        
                        Text("you got \(winner)!!")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("HURRAH!! HUZZAH!!")
                            .font(.title2)
                            .foregroundColor(.pink)
                        
                        Text("Tap to continue")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(30)
                    .background(Color(.systemBackground))
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .scaleEffect(showPopup ? 1.0 : 0.8)
                    .animation(.spring(response: 0.3, dampingFraction: 0.8), value: showPopup)
                    .onTapGesture {
                        showPopup = false
                    }
                }
            }
        )
    }

    func spin() {
        isSpinning = true
        winner = ""
        
        let randomSpins = Double.random(in: 720...1080)
        rotation += randomSpins
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            isSpinning = false
            let winnerIndex = Int((rotation.truncatingRemainder(dividingBy: 360)) / 90)
            winner = prizes[3 - winnerIndex]
            
            // Add score if winner is sugar
            if winner == "sugar" {
                gameData.score += 100
            }
            
            showPopup = true
        }
    }
}

struct PieSlice: Shape {
    let startAngle: Double
    let endAngle: Double
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        path.move(to: center)
        path.addArc(
            center: center,
            radius: radius,
            startAngle: .degrees(startAngle - 90),
            endAngle: .degrees(endAngle - 90),
            clockwise: false
        )
        path.closeSubpath()
        
        return path
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    LuckyDrawView()
        .environmentObject(GameData())
}
