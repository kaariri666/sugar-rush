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
    @StateObject var gameData = GameData()
    @State var showTutorial = false
    var body: some View {
        NavigationStack {
            VStack{
                HStack{
                    Spacer()
                    Button{
                        showTutorial = true
                    }label:{
                        Text("tutorial")
                        
                    }
                    .buttonStyle(.borderedProminent)
                    Spacer()
                    
                    NavigationLink {
                        Minigames_()
                    } label:{
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
                Text("Score: \(gameData.score)")
                
                Spacer()
                Image("uglyguy")
                    .resizable()
                    .frame(width: 400, height: 400)
                    .navigationTitle(Text("Sugar Rush"))
            }
            
            .sheet(isPresented: $showTutorial){
                tutorialview()
            }
        }
    }
}
#Preview {
    Home_page()
}

