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
    
    var body: some View {
        
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
                    VStack(spacing: 5) {
                        
                        Circle()
                            .stroke(Color.gray.opacity(0.7), lineWidth: 2)
                        
                        Text("\(calendar.component(.day, from: date))")
                            .font(.footnote)
                            .foregroundColor(.primary)
                    }
                    
                    .padding(5)
                }
            }
            .padding()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(
                    AngularGradient(
                        gradient: Gradient(colors: [.red, .orange, .yellow, .green, .blue, .purple, .red]),
                        center: .center,
                        angle: .degrees(rotation)
                    ),
                    lineWidth: 2
                )
                .animation(.linear(duration: 4).repeatForever(autoreverses: false), value: rotation)
        )
        .onAppear {
            rotation = 360
        }
        
        .padding()
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
    
}

#Preview {
    MemoriesView()
}
