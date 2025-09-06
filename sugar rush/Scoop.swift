//
//  Scoop.swift
//  sugar rush
//
//  Created by Dilan Subhu Veerappan on 13/6/25.
//

import SwiftUI

struct Scoop: Identifiable {
    let id = UUID()
    let color: Color
    let flavor: String
    
    static let flavors = [
        ("Dark Brown Sugar", Color.brown),
        ("Cane Sugar", Color.white),
        ("Light Brown Sugar", Color(red: 0.8, green: 0.6, blue: 0.4)),
        ("Chocolate Sugar", Color(red: 0.6, green: 0.4, blue: 0.2)),
        ("Vanilla Sugar", Color(red: 0.95, green: 0.95, blue: 0.9)),
        ("Strawberry Sugar", Color(red: 1.0, green: 0.7, blue: 0.8))
    ]
    
    static func random() -> Scoop {
        let (flavor, color) = flavors.randomElement()!
        return Scoop(color: color, flavor: flavor)
    }
}

