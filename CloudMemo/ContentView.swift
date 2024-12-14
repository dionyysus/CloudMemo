//
//  ContentView.swift
//  CloudMemo
//
//  Created by Gizem Coskun on 10/12/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            StatisticView()
                .tabItem {
                    Label("Stats", systemImage: "flame.fill")
                }
            
            MemoriesView()
                .tabItem {
                    Label("Memories", systemImage: "calendar")
                }
        }.tint(.black)
    }
}

#Preview {
    ContentView()
}
