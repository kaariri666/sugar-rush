//
//  Minigames .swift
//  sugar rush
//
//  Created by Julia Li on 16/8/25.
//
import SwiftUI

struct Minigames_: View {
    @State private var showingCatchingSugar = false
    @State private var showingCollectingSugar = false
    @State private var showingShootingSugar = false
    @State private var showingLuckyDraw = false
    
    var body: some View {
        VStack{
            Text("__Minigames__")
                .font(.largeTitle)
            Text("(50) Normal Sugar:   (100) Mentor Sugar:   ")
            
            
            Button{
                showingCatchingSugar = true
            }label:{
                Text("__Catching Sugar__             ")
            }
            .buttonStyle(.borderedProminent)
            .font(.largeTitle)
            .tint(.purple)
            .padding()
                .fullScreenCover(isPresented: $showingCatchingSugar) {
                    CatchingSugarView()
                }
            
            Button{
                showingShootingSugar = true
            }label:{
                Text("__Shooting Sugar__             ")
            }
            .buttonStyle(.borderedProminent)
            .font(.largeTitle)
            .tint(.blue)
            .padding()
                .fullScreenCover(isPresented: $showingShootingSugar) {
                    ShootingSugar()
                }
            
            Button{
                showingCollectingSugar = true
            }label:{
                Text("__Collecting Sugar__            ")
            }
            .buttonStyle(.borderedProminent)
            .font(.largeTitle)
            .tint(.teal)
            .padding()
            .fullScreenCover(isPresented: $showingCollectingSugar) {
                    collectingSugar()
                }
            
            Button{
                showingLuckyDraw = true
            }label:{
                Text("__Lucky Draw__                      ")
            }
            .buttonStyle(.borderedProminent)
            .font(.largeTitle)
            .tint(.green)
            .padding()
            Spacer()
                .fullScreenCover(isPresented: $showingLuckyDraw) {
                    LuckyDrawView()
                }
            
        }
    }
}
#Preview {
    Minigames_()
}

