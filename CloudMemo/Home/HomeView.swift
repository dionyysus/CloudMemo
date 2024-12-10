//
//  HomeView.swift
//  CloudMemo
//
//  Created by Gizem Coskun on 10/12/24.
//

import SwiftUI

struct HomeView: View {
    
    @State private var displayedText: String = ""
    
    let items = [
        ("awesome", "Awesome"),
        ("happy", "Happy"),
        ("okay", "Okay"),
        ("sad", "Sad"),
        ("angry", "Angry"),
        ("terrible", "Terrible")]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            Image(systemName: "cloud.fill")
                .font(.largeTitle)
                .foregroundColor(.black)
                .padding()
            
            Text("How are you feeling today?")
                .font(.title3)
                .fontWeight(.semibold)
            
            TextEditor(text: $displayedText)
                .background(Color.white.opacity(0.2))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .padding()
            
            Text("Choose your mood")
                .font(.title3)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            
            
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(0..<items.count, id: \.self) { index in
                    VStack {
                        Image(items[index].0)
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        Text(items[index].1)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                }
            }
            .padding()
            
            Button(action: {}, label: {
                Text("Add" .uppercased())
                    .font(.caption)
                    .fontWeight(.bold)
                    .bold()
                    .foregroundColor(.white)
                    .padding()
                    .padding(.horizontal, 10)
                    .background(
                        Capsule()
                            .fill(Color.black)
                    )
            }).padding()
        }
    }
}

struct StatsView: View {
    var body: some View {
        VStack {
            Text("Stats")
                .font(.largeTitle)
                .padding()
            Spacer()
        }
    }
}

struct MemoriesView: View {
    var body: some View {
        VStack {
            Text("Memories")
                .font(.largeTitle)
                .padding()
            Spacer()
        }
    }
}

struct ContenttView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            StatsView()
                .tabItem {
                    Label("Stats", systemImage: "flame.fill")
                }
            
            MemoriesView()
                .tabItem {
                    Label("Memories", systemImage: "calendar")
                }
        }.tint(.black)
        
        /*TODO: search about it
         .tabViewStyle(.page)
         */
        
    }
}

#Preview {
    ContenttView()
}
