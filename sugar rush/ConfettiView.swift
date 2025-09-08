//
//  ConfettiView.swift
//  sugar rush
//
//  Created by Ashley Leng on 8/9/25.
//

import SwiftUI

struct ConfettiView: View {
    @State private var confetti: [ConfettiPiece] = []
    @State private var animationTimer: Timer?
    
    struct ConfettiPiece {
        var x: CGFloat
        var y: CGFloat
        var velocityX: CGFloat
        var velocityY: CGFloat
        var color: Color
        var opacity: Double = 1.0
        var rotation: Double = 0
        var rotationSpeed: Double
        var scale: CGFloat = 1.0
    }
    
    var body: some View {
        ZStack {
            ForEach(0..<confetti.count, id: \.self) { index in
                Rectangle()
                    .fill(confetti[index].color)
                    .frame(width: 8, height: 12)
                    .scaleEffect(confetti[index].scale)
                    .rotationEffect(.degrees(confetti[index].rotation))
                    .opacity(confetti[index].opacity)
                    .position(x: confetti[index].x, y: confetti[index].y)
            }
        }
        .onAppear {
            createExplosion()
        }
    }
    
    func createExplosion() {
        let colors: [Color] = [.red, .orange, .yellow, .pink, .purple, .blue, .green, .cyan]
        
        for _ in 0..<80 {
            let piece = ConfettiPiece(
                x: 110,
                y: 200,
                velocityX: CGFloat.random(in: -300...300),
                velocityY: CGFloat.random(in: -400...100),
                color: colors.randomElement() ?? .red,
                rotationSpeed: Double.random(in: -720...720)
            )
            confetti.append(piece)
        }
        
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
            updateConfetti()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            animationTimer?.invalidate()
        }
    }
    
    func updateConfetti() {
        for i in 0..<confetti.count {
            confetti[i].x += confetti[i].velocityX * 0.02
            confetti[i].y += confetti[i].velocityY * 0.02
            confetti[i].velocityY += 300 * 0.02
            confetti[i].rotation += confetti[i].rotationSpeed * 0.02
            confetti[i].opacity -= 0.006
            confetti[i].scale *= 0.995
        }
    }
}

#Preview {
    ConfettiView()
}
