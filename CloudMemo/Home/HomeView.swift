//
//  HomeView.swift
//  CloudMemo
//
//  Created by Gizem Coskun on 10/12/24.
//

import SwiftUI

struct HomeView: View {
    
    @State private var displayedText: String = ""
    @State private var selectedMood: Int? = nil
    
    
    let items = [
        ("awesomecloud", "Awesome"),
        ("happycloud", "Happy"),
        ("okaycloud", "Okay"),
        ("sadcloud", "Sad"),
        ("angrycloud", "Angry"),
        ("terriblecloud", "Terrible")]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
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
                                .stroke(selectedMood == index ? Color.blue : Color.gray, lineWidth: 1)
                        )
                        .onTapGesture {
                            selectedMood = selectedMood == index ? nil : index
                        }
                    }
                }
                .padding()
                
                
                NavigationLink(destination: CircleComplete()) {
                    Text("Add".uppercased())
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .padding(.horizontal, 10)
                        .background(
                            Capsule()
                                .fill(Color.black)
                        )
                }
                .padding()
            }
        }
    }
}

#Preview {
    ContentView()
}
