//
//  ScoopView.swift
//  sugar rush
//
//  Created by Dilan Subhu Veerappan on 13/6/25.
//

import SwiftUI

struct ScoopView: View {
    let scoop: Scoop
    
    var body: some View {
        Circle()
            .fill(scoop.color)
            .frame(width: 80, height: 80)
            .shadow(radius: 3)
            .overlay(
                Circle()
                    .stroke(Color.white, lineWidth: 2)
            )
    }
}

