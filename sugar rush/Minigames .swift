//
//  Minigames .swift
//  sugar rush
//
//  Created by Julia Li on 16/8/25.
//
import SwiftUI

struct Minigames_: View {
    @State private var showingFullScreen = false
    var body: some View {
        VStack{
            Text("__Minigames__")
                .font(.largeTitle)
            Text("(50) Normal Sugar:   (100) Mentor Sugar:   ")
            
            
            Button{
                showingFullScreen = true
            }label:{
                Text("__Catching Sugar__             ")
            }
            .buttonStyle(.borderedProminent)
            .font(.largeTitle)
            .tint(.purple)
            .padding()
                .fullScreenCover(isPresented: $showingFullScreen) {
                    CatchingSugarView()
                }
            
            Button{
                showingFullScreen = true
            }label:{
                Text("__Shooting Sugar__             ")
            }
            .buttonStyle(.borderedProminent)
            .font(.largeTitle)
            .tint(.blue)
            .padding()
                .fullScreenCover(isPresented: $showingFullScreen) {
                    ShootingSugar()
                }
            
            Button{
                showingFullScreen = true
            }label:{
                Text("__Collecting Sugar__            ")
            }
            .buttonStyle(.borderedProminent)
            .font(.largeTitle)
            .tint(.teal)
            .padding()
                .fullScreenCover(isPresented: $showingFullScreen) {
                    collectingSugar()
                }
            
            Button{
                showingFullScreen = true
            }label:{
                Text("__Catching Sugar__              ")
            }
            .buttonStyle(.borderedProminent)
            .font(.largeTitle)
            .tint(.green)
            .padding()
            Spacer()
                .fullScreenCover(isPresented: $showingFullScreen) {
                    LuckyDrawView()
                }
            
        }
    }
}
#Preview {
    Minigames_()
}

