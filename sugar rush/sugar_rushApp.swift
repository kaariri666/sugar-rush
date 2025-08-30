//
//  sugar_rushApp.swift
//  sugar rush
//
//  Created by Ashley Leng on 2/8/25.
//

import SwiftUI

@main
struct YourApp: App {
    @StateObject private var gameData = GameData()
    
    var body: some Scene {
        WindowGroup {
            Home_page()
                .environmentObject(gameData)
        }
    }
}

