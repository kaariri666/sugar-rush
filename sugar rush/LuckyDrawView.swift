//
//  luckyDraw.swift
//  sugar rush
//
//  Created by Julia Li on 16/8/25.
//

import SwiftUI

struct LuckyDrawView: View {
    @State var rotation = 0.0
    @State var isSpinning = false
    @State var winner = ""

    let prizes = ["nothing", "nothing", "nothing", "sugar"]
    let colors = [Color.pink, Color.purple, Color.teal, Color.orange]

    var body: some View {
        VStack {
            Text("spin it")
                .font(.title)
                .padding()

            ZStack {
                ForEach(0..<4) { i in
                    PieSlice(startAngle: Double(i) * 90, endAngle: Double(i + 1) * 90)
                        .fill(colors[i])
                    
                    Text(prizes[i])
                        .font(.headline)
                        .foregroundColor(.white)
                        .offset(y: -50)
                        .rotationEffect(.degrees(Double(i) * 90 + 45))
                }
            }
            .frame(width: 200, height: 200)
            .rotationEffect(.degrees(rotation))
            .animation(.easeOut(duration: 3), value: rotation)
            
            Triangle()
                .fill(Color.black)
                .frame(width: 20, height: 20)
                .offset(y: -10)
            
            if !winner.isEmpty {
                Text("you won \(winner)!!")
                    .font(.title2)
                    .foregroundColor(.red)
                Text("HURRAH!! HUZZAH!!")
                    .font(.title2)
                    .foregroundColor(.pink)
            }

            Button("SPIN") {
                spin()
            }
            .font(.title)
            .padding()
            .background(Color.purple)
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(isSpinning)
        }
        .padding()
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
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    LuckyDrawView()
}
