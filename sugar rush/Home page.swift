//
//  Home page.swift
//  sugar rush
//
//  Created by Julia Li on 16/8/25.
//
import SwiftUI

class GameData: ObservableObject {
    @Published var score: Int = 0
}

struct Home_page: View {
    @EnvironmentObject var gameData: GameData  
    @State var showTutorial = false
    
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
                Spacer()
                
                Text("__Amount of Sugar__")
                    .font(.largeTitle)
                    .position(x: 200, y: 50)
                
                Text("Score: \(gameData.score)")
                    .position(x: 200, y: 70)
                
                Spacer()
                Image("kmy")
                    .resizable()
                    .frame(width: 600, height: 600)
                    .navigationTitle(Text("Sugar Rush"))
            }
            .sheet(isPresented: $showTutorial) {
                tutorialview()
            }
        }
    }
}

#Preview {
    Home_page()
        .environmentObject(GameData())
}
