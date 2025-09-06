//
//  ScoopDetailView.swift
//  sugar rush
//
//  Created by Dilan Subhu Veerappan on 13/6/25.
//

import SwiftUI

struct ScoopDetailView: View {
    let scoop: Scoop
    
    var body: some View {
        VStack(spacing: 20) {
            Circle()
                .fill(scoop.color)
                .frame(width: 200, height: 200)
                .shadow(radius: 5)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 3)
                )
            
            Text("Sugar Scoop Details")
                .font(.title)
                .bold()
            
            Text("Type: \(scoop.flavor)")
                .font(.title2)
            
            Text("Sweetness Level: ★★★★★")
                .font(.title3)
                .foregroundColor(.yellow)
        }
        .padding()
        .navigationTitle("Sugar Details")
    }
}

