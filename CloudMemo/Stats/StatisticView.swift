//
//  StatisticView.swift
//  CloudMemo
//
//  Created by Gizem Coskun on 10/12/24.
//

import SwiftUI

struct StatisticView: View {
    
    let moodCountsKey = "moodCounts"
    
    @State private var moodCounts: [String: Int] = [:]
    
    var body: some View {
        VStack {
            
            Image(systemName: "flame.fill")
                .resizable()
                .scaledToFit()
                .foregroundStyle(Color.orange)
                .padding()
            Text("\(fetchStreak())")
                .font(.title)
                .fontWeight(.bold)
            Text("Day Streak")
                .font(.title)
                .fontWeight(.bold)
            Text("You are doing really great!")
                .font(.title2)
                .fontWeight(.light)
            
            VStack(spacing: 20) {
                HStack(spacing: 20) {
                    moodCloud(mood: "Awesome", count: moodCounts["Awesome"] ?? 0, color: .green, imageName: "awesomecloud")
                    moodCloud(mood: "Happy", count: moodCounts["Happy"] ?? 0, color: .yellow, imageName: "happycloud")
                    moodCloud(mood: "Okay", count: moodCounts["Okay"] ?? 0, color: .blue, imageName: "okaycloud")
                }
                
                HStack(spacing: 20) {
                    moodCloud(mood: "Sad", count: moodCounts["Sad"] ?? 0, color: .purple, imageName: "sadcloud")
                    moodCloud(mood: "Angry", count: moodCounts["Angry"] ?? 0, color: .red, imageName: "angrycloud")
                    moodCloud(mood: "Terrible", count: moodCounts["Terrible"] ?? 0, color: .pink, imageName: "terriblecloud")
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray, lineWidth: 2)
            )
        }
        .padding()
        .onAppear {
            self.moodCounts = fetchMoodCounts()
        }
    }
    
    private func moodCloud(mood: String, count: Int, color: Color, imageName: String) -> some View {
        VStack {
            ZStack(alignment: .topLeading) {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                Text("\(count)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(4)
                    .background(color.opacity(0.5))
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .padding([.top, .leading], 5)
            }
            Text(mood)
                .font(.caption)
                .fontWeight(.light)
        }
    }
    
    private func fetchMoodCounts() -> [String: Int] {
        let moodCounts = UserDefaults.standard.dictionary(forKey: moodCountsKey) as? [String: Int] ?? [:]
        return moodCounts
    }
    
    private func fetchStreak() -> Int {
        return UserDefaults.standard.integer(forKey: "streak")
    }
}

#Preview {
    StatisticView()
}
