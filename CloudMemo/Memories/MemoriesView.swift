//
//  MemoriesView.swift
//  CloudMemo
//
//  Created by Gizem Coskun on 11/12/24.
//

import SwiftUI
import CloudKit

struct MemoriesView: View {
    let calendar = Calendar.current
    @State private var currentDate = Date()
    @State private var animate = false
    @State private var rotation: CGFloat = 0.0
    
    private let dataKey = "dailyEntries"
    
    var body: some View {
        NavigationView {
            VStack {
                Text(formattedMonthYear(from: currentDate))
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                HStack {
                    ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                        Text(day)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.bottom, 5)
                
                let days = daysInMonth(for: currentDate)
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                    ForEach(days, id: \.self) { date in
                        NavigationLink(destination: MoodDetailView(date: date)) {
                            VStack(spacing: 5) {
                                Circle()
                                    .fill(moodColor(for: date))
                                    .frame(width: 30, height: 30)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.gray.opacity(0.7), lineWidth: 2)
                                    )
                                
                                Text("\(calendar.component(.day, from: date))")
                                    .font(.footnote)
                                    .foregroundColor(.primary)
                            }
                            .padding(5)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(
                        AngularGradient(
                            gradient: Gradient(colors: [.purple, .orange, .green, .blue]),
                            center: .center,
                            angle: .degrees(rotation)
                        ),
                        lineWidth: 4
                    )
                    .animation(.linear(duration: 3).repeatForever(autoreverses: false), value: rotation)
            )
            .onAppear {
                rotation = 360
            }
            .padding()
        }
    }
    
    private func daysInMonth(for date: Date) -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: date) else { return [] }
        let startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: monthInterval.start))!
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        
        return range.compactMap { day -> Date? in
            calendar.date(byAdding: .day, value: day - 1, to: startDate)
        }
    }
    
    private func formattedMonthYear(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    private func moodColor(for date: Date) -> Color {
        let formattedDate = formattedDate(date)
        let dailyEntries = UserDefaults.standard.dictionary(forKey: dataKey) as? [String: [String: Any]] ?? [:]
        if let entry = dailyEntries[formattedDate], let mood = entry["mood"] as? Int {
            let moodColors: [Color] = [.green, .yellow, .blue, .purple, .red, .pink]
            return mood >= 0 && mood < moodColors.count ? moodColors[mood] : .gray
        }
        return .clear
    }
}

struct MoodDetailView: View {
    var date: Date
    @State private var displayedText: String = ""
    @State private var selectedMood: Int? = nil
    
    private let dataKey = "dailyEntries"
    private let items = [
        ("awesomecloud", "Awesome", Color.green),
        ("happycloud", "Happy", Color.yellow),
        ("okaycloud", "Okay", Color.blue),
        ("sadcloud", "Sad", Color.purple),
        ("angrycloud", "Angry", Color.red),
        ("terriblecloud", "Terrible", Color.pink)
    ]
    
    var body: some View {
        VStack {
            Text("Mood Details for \(formattedDate(date))")
                .font(.title)
                .padding()
            
            if let mood = selectedMood {
                Text("Mood: \(items[mood].1)")
                    .font(.title2)
                    .padding()
            } else {
                Text("No mood selected.")
                    .font(.title2)
                    .padding()
            }
            
            if !displayedText.isEmpty {
                Text("Text Entry:")
                    .font(.headline)
                    .padding(.top)
                Text(displayedText)
                    .font(.body)
                    .padding()
            } else {
                Text("No text entry for today.")
                    .font(.body)
                    .padding()
            }
            
            Spacer()
        }
        .navigationTitle("Mood Details")
        .padding()
        .onAppear {
            loadDailyEntryData()
        }
    }
    
    private func loadDailyEntryData() {
        let formattedDate = formattedDate(date)
        let dailyEntries = UserDefaults.standard.dictionary(forKey: dataKey) as? [String: [String: Any]] ?? [:]
        
        if let entry = dailyEntries[formattedDate] {
            displayedText = entry["text"] as? String ?? ""
            selectedMood = entry["mood"] as? Int
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        return formatter.string(from: date)
    }
}


#Preview {
    MemoriesView()
}
