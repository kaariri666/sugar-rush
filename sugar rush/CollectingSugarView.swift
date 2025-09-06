//
//  CollectingSugarView.swift
//  sugar rush
//
//  Created by Dilan Subhu Veerappan on 13/6/25.
//

import SwiftUI

struct CollectingSugarView: View {
    @State private var scoops: [Scoop] = []
    @EnvironmentObject var gameData: GameData
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Sugar Collected: \(scoops.count)")
                        .font(.title2)
                        .bold()
                    Spacer()
                    Text("Total Score: \(gameData.score)")
                        .font(.title2)
                        .bold()
                }
                .padding()
                
                ScrollView {
                    VStack(spacing: -40) {
                        ForEach(scoops) { scoop in
                            NavigationLink(destination: ScoopDetailView(scoop: scoop)) {
                                ScoopView(scoop: scoop)
                            }
                        }
                        
                        //basket
                        Image("basket")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(Color(red: 0.8, green: 0.7, blue: 0.5))
                    }
                    .padding(.top, 50)
                }
                
                Button(action: {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        scoops.insert(Scoop.random(), at: 0)
                        gameData.score += 10
                    }
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Collect Sugar!")
                    }
                    .font(.title2)
                    .padding()
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.orange, Color.red]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                }
                .padding(.bottom)
                
                if !scoops.isEmpty {
                    Button(action: {
                        withAnimation {
                            scoops.removeAll()
                        }
                    }) {
                        HStack {
                            Image(systemName: "trash.circle.fill")
                            Text("Clear Collection")
                        }
                        .font(.title3)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding(.bottom)
                }
            }
            .navigationTitle("Sugar Collector")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    CollectingSugarView()
        .environmentObject(GameData())
}
