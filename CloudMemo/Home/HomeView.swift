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
                        .background(
                            Capsule()
                                .fill(Color.black)
                        )
                }
                
                .padding()
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
                streak = UserDefaults.standard.integer(forKey: "streak")
                if entryExistsForToday() {
                    let selectedMoodIndex = UserDefaults.standard.integer(forKey: "selectedMood")
                    selectedMood = selectedMoodIndex
                    navigateToCircleComplete = true
                }
            }
        }
    }
   
    
    private func setupToday() {
        today = formattedDate(from: Date())
    }
    
    private func saveDataForToday() {
        var dailyEntries: [String: [String: Any]] = loadDailyEntries()
        let yesterday: String = {
            let previousDay = Calendar.current.date(byAdding: .day, value: -1, to: Date())
            let formattedYesterday = formattedDate(from: previousDay ?? Date())
            return formattedDate(from: previousDay ?? Date())
        }()
        
        updateStreak(dailyEntries: dailyEntries, yesterday: yesterday)
        saveDailyEntry(&dailyEntries)
        saveMoodColor()
        updateMoodCounts()
    }

    private func updateMoodCounts() {
        var moodCounts: [String: Int] = UserDefaults.standard.dictionary(forKey: "moodCounts") as? [String: Int] ?? [:]
        
        guard let selectedMood = selectedMood else { return }
        let moodName = items[selectedMood].1
        let currentCount = moodCounts[moodName] ?? 0
        moodCounts[moodName] = currentCount + 1
        
        UserDefaults.standard.set(moodCounts, forKey: "moodCounts")
    }

    private func saveDailyEntry(_ dailyEntries: inout [String: [String: Any]]) {
        let entry: [String: Any] = [
            "text": displayedText,
            "mood": selectedMood ?? -1
        ]
        dailyEntries[today] = entry
        UserDefaults.standard.set(dailyEntries, forKey: dataKey)
    }

    private func updateStreak(dailyEntries: [String: [String: Any]], yesterday: String) {
        if dailyEntries[today] == nil {
            streak = dailyEntries[yesterday] != nil ? streak + 1 : 1
        }
        UserDefaults.standard.set(streak, forKey: "streak")
    }

    private func saveMoodColor() {
        guard let selectedMood = selectedMood else { return }
        let moodColor = UIColor(items[selectedMood].2)
        let colorData: Data?
        do {
            colorData = try NSKeyedArchiver.archivedData(withRootObject: moodColor, requiringSecureCoding: false)
        } catch {
            colorData = nil
        }

        UserDefaults.standard.set(colorData, forKey: "selectedMoodColor")
    }

    private func formattedDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    private func loadDailyEntries() -> [String: [String: Any]] {
        UserDefaults.standard.dictionary(forKey: dataKey) as? [String: [String: Any]] ?? [:]
    }
    
    private func entryExistsForToday() -> Bool {
        var dailyEntries: [String: [String: Any]] = loadDailyEntries()
        return dailyEntries[today] != nil
    }
    
    private func selectedMoodColor() -> Color {
        guard let selectedMood = selectedMood else { return .gray }
        return items[selectedMood].2
    }
    
    private func loadMoodCounts() {
        let moodCountsKey = "moodCounts"
        moodCounts = UserDefaults.standard.dictionary(forKey: moodCountsKey) as? [String: Int] ?? [:]
    }
    
    private func loadMoodColor() -> Color {
        if let colorData = UserDefaults.standard.data(forKey: "selectedMoodColor"),
           let uiColor = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colorData) as? UIColor {
            return Color(uiColor)
        }
        return .gray
    }
}

#Preview {
    ContentView()
}
