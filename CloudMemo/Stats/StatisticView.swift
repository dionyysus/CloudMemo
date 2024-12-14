//
//  StatisticView.swift
//  CloudMemo
//
//  Created by Gizem Coskun on 10/12/24.
//

import SwiftUI

struct StatisticView: View {
    
    private func fetchMoodCounts() -> [String: Int] {
        let moodCountsKey = "moodCounts"
        return UserDefaults.standard.dictionary(forKey: moodCountsKey) as? [String: Int] ?? [:]
    }
    
    var body: some View {
        VStack {
            
            Image(systemName: "flame.fill")
                .resizable()
                .scaledToFit()
                .foregroundStyle(Color.orange)
                .padding()
            Text("2")
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
                    VStack {
                        ZStack(alignment: .topLeading) {
                            Image("awesomecloud")
                                .resizable()
                                .scaledToFit()
                            Text("\(fetchMoodCounts()["Awesome"] ?? 0)")
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(4)
                                .background(Color.green.opacity(0.5))
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .padding([.top, .leading], 5)
                        }
                        Text("Awesome")
                            .font(.caption)
                            .fontWeight(.light)
                    }
                    
                    VStack {
                        ZStack(alignment: .topLeading) {
                            Image("happycloud")
                                .resizable()
                                .scaledToFit()
                            Text("\(fetchMoodCounts()["Happy"] ?? 0)")  // Dynamically show the count for "Happy"
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(4)
                                .background(Color.yellow.opacity(0.5))
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .padding([.top, .leading], 5)
                        }
                        Text("Happy")
                            .font(.caption)
                            .fontWeight(.light)
                    }
                    
                    VStack {
                        ZStack(alignment: .topLeading) {
                            Image("okaycloud")
                                .resizable()
                                .scaledToFit()
                            Text("\(fetchMoodCounts()["Okay"] ?? 0)")  // Dynamically show the count for "Okay"
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(4)
                                .background(Color.blue.opacity(0.5))
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .padding([.top, .leading], 5)
                        }
                        Text("Okay")
                            .font(.caption)
                            .fontWeight(.light)
                    }
                }
                
                HStack(spacing: 20) {
                    VStack {
                        ZStack(alignment: .topLeading) {
                            Image("sadcloud")
                                .resizable()
                                .scaledToFit()
                            Text("\(fetchMoodCounts()["Sad"] ?? 0)")
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(4)
                                .background(Color.purple.opacity(0.5))
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .padding([.top, .leading], 5)
                        }
                        Text("Sad")
                            .font(.caption)
                            .fontWeight(.light)
                    }
                    
                    VStack {
                        ZStack(alignment: .topLeading) {
                            Image("angrycloud")
                                .resizable()
                                .scaledToFit()
                            Text("\(fetchMoodCounts()["Angry"] ?? 0)")
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(4)
                                .background(Color.red.opacity(0.5))
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .padding([.top, .leading], 5)
                        }
                        Text("Angry")
                            .font(.caption)
                            .fontWeight(.light)
                    }
                    
                    VStack {
                        ZStack(alignment: .topLeading) {
                            Image("terriblecloud")
                                .resizable()
                                .scaledToFit()
                            Text("\(fetchMoodCounts()["Terrible"] ?? 0)")  // Dynamically show the count for "Terrible"
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(4)
                                .background(Color.pink.opacity(0.5))
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .padding([.top, .leading], 5)
                        }
                        Text("Terrible")
                            .font(.caption)
                            .fontWeight(.light)
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray, lineWidth: 2)
            )
        }
        .padding()
        
    }
}

#Preview {
    StatisticView()
}

