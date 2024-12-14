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
    
    @State private var moodCounts: [String: Int] = [:]
    
    @State private var streak: Int = 0
    
    @State private var navigateToCircleComplete: Bool = false
    
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
                
                NavigationLink(destination: CircleComplete(selectedColor: selectedMoodColor()), isActive: $navigateToCircleComplete) {
                    Text("Add".uppercased())
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .padding(.horizontal, 10)
                        .background(Capsule().fill(Color.black))
                }
                .simultaneousGesture(TapGesture().onEnded {
                    saveDataForToday()
                    navigateToCircleComplete = true
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
                loadMoodCounts()
                streak = UserDefaults.standard.integer(forKey: "streak") // Load streak
                if entryExistsForToday() {
                    selectedMood = UserDefaults.standard.integer(forKey: "selectedMood") // Reload selected mood
                    navigateToCircleComplete = true
                }
            }
        }
    }
    
    private func setupToday() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        today = formatter.string(from: Date())
    }
    
    private func saveDataForToday() {
        var dailyEntries = UserDefaults.standard.dictionary(forKey: dataKey) as? [String: [String: Any]] ?? [:]
        let previousDay = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let yesterday = formatter.string(from: previousDay ?? Date())
        
        if dailyEntries[today] == nil {
            // Update streak logic
            if dailyEntries[yesterday] != nil {
                streak += 1 // Continue streak
            } else {
                streak = 1 // Reset streak
            }
        }
        
        dailyEntries[today] = [
            "text": displayedText,
            "mood": selectedMood ?? -1,
            "color": selectedMoodColor().description // Save the color as a string (e.g., for yellow: .yellow)
        ]
        UserDefaults.standard.set(dailyEntries, forKey: dataKey)
        UserDefaults.standard.set(streak, forKey: "streak") // Save streak

        // Update mood counts
        var moodCounts = UserDefaults.standard.dictionary(forKey: "moodCounts") as? [String: Int] ?? [:]
        if let selectedMood = selectedMood {
            let moodName = items[selectedMood].1
            moodCounts[moodName, default: 0] += 1
        }
        UserDefaults.standard.set(moodCounts, forKey: "moodCounts")
    }

    private func entryExistsForToday() -> Bool {
        let dailyEntries = UserDefaults.standard.dictionary(forKey: dataKey) as? [String: [String: Any]] ?? [:]
        return dailyEntries[today] != nil
    }
    
    private func selectedMoodColor() -> Color {
        guard let selectedMood = selectedMood else { return .gray }
        return items[selectedMood].2
    }


    func loadMoodColor() -> Color {
        if let colorData = UserDefaults.standard.data(forKey: "selectedMoodColor"),
           let uiColor = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colorData) as? UIColor {
            return Color(uiColor)
        }
        return .gray
    }

    // Load mood counts from UserDefaults into the state
    private func loadMoodCounts() {
        let moodCountsKey = "moodCounts"
        moodCounts = UserDefaults.standard.dictionary(forKey: moodCountsKey) as? [String: Int] ?? [:]
    }
}


#Preview {
    ContentView()
}
