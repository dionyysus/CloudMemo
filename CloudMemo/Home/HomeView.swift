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
    @State private var today: String = ""
    @FocusState private var isTextEditorFocused: Bool
    
    private let dataKey = "dailyEntries"
    
    let items = [
        ("awesomecloud", "Awesome", Color.green),
        ("happycloud", "Happy", Color.yellow),
        ("okaycloud", "Okay", Color.blue),
        ("sadcloud", "Sad", Color.purple),
        ("angrycloud", "Angry", Color.red),
        ("terriblecloud", "Terrible", Color.pink)
    ]
    
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
                    .focused($isTextEditorFocused)
                    .frame(height: 150)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .padding()
                    .disabled(entryExistsForToday())
                
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
                                .stroke(selectedMood == index ? items[index].2 : Color.gray, lineWidth: 2)
                        )
                        .onTapGesture {
                            guard !entryExistsForToday() else { return }
                            selectedMood = selectedMood == index ? nil : index
                            isTextEditorFocused = false
                        }
                    }
                }
                .padding()
                .disabled(entryExistsForToday())
                
                NavigationLink(destination: CircleComplete(selectedColor: selectedMoodColor())) {
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
                .simultaneousGesture(TapGesture().onEnded {
                    saveDataForToday()
                })
                .disabled(entryExistsForToday())
                
                if entryExistsForToday() {
                    Text("You've already added an entry for today!")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
            .onTapGesture {
                isTextEditorFocused = false
            }
            .onAppear {
                setupToday()
            }
        }
    }
    
    private func setupToday() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        today = formatter.string(from: Date())
    }
    
    private func saveDataForToday() {
        // Save daily entry data
        var dailyEntries = UserDefaults.standard.dictionary(forKey: dataKey) as? [String: [String: Any]] ?? [:]
        dailyEntries[today] = [
            "text": displayedText,
            "mood": selectedMood ?? -1
        ]
        UserDefaults.standard.set(dailyEntries, forKey: dataKey)
        
        // Update mood counts
        let moodCountsKey = "moodCounts"
        var moodCounts = UserDefaults.standard.dictionary(forKey: moodCountsKey) as? [String: Int] ?? [:]
        
        if let selectedMood = selectedMood {
            let moodName = items[selectedMood].1 // Get the name of the selected mood (e.g., "Awesome")
            moodCounts[moodName, default: 0] += 1 // Increase the count for that mood
        }
        
        UserDefaults.standard.set(moodCounts, forKey: moodCountsKey)
        print("Mood counts updated: \(moodCounts)")
        print("Data saved for \(today): \(displayedText), Mood: \(selectedMood ?? -1)")
    }

    private func fetchMoodCounts() -> [String: Int] {
        // Fetch mood counts from UserDefaults
        let moodCountsKey = "moodCounts"
        return UserDefaults.standard.dictionary(forKey: moodCountsKey) as? [String: Int] ?? [:]
    }
    
    private func entryExistsForToday() -> Bool {
        let dailyEntries = UserDefaults.standard.dictionary(forKey: dataKey) as? [String: [String: Any]] ?? [:]
        return dailyEntries[today] != nil
    }
    
   
    private func selectedMoodColor() -> Color {
        guard let selectedMood = selectedMood else { return .gray }
        return items[selectedMood].2
    }
}


#Preview {
    ContentView()
}
