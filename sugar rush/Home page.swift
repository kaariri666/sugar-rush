//
//  Home page.swift
//  sugar rush
//
//  Created by Julia Li on 16/8/25.
//

import SwiftUI

struct Home_page: View {
    @State var showTutorial = false
    var body: some View {
        NavigationStack {
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
            
                .navigationTitle(Text("Sugar Rush"))
        }
        
        .sheet(isPresented: $showTutorial){
            tutorialview()
        }
    }
}

#Preview {
    Home_page()
}
