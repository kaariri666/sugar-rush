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
                
                Text("_Amount of Sugar_")
                    .clipShape(.rect(cornerRadius: 10))
                    .backgroundStyle(.red)
                    .position(x: 300, y: 285)
                    .font(.title2)

                
                Spacer()
                
                ZStack {
                    Image("kmy")
                        .resizable()
                        .frame(width: 300, height: 500)
                        .position(x: 110, y: 60)
                    
                    Image("jar")
                        .resizable()
                        .frame(width: 200, height: 300)
                        .position(x: 300, y: 120)
                    
                    Text("Score: \(gameData.score)")
                        .font(.title)
                        .foregroundColor(.black)
                        .position(x: 300, y: 140) //
                }
                
                Spacer()
            }
            .navigationTitle(Text("Sugar Rush"))
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
