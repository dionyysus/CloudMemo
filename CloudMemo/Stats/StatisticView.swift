//
//  StatisticView.swift
//  CloudMemo
//
//  Created by Gizem Coskun on 10/12/24.
//

import SwiftUI

struct StatisticView: View {
    var body: some View {
        VStack() {
            Image(.streak)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
            Text("Day Streak")
                .font(.title)
                .fontWeight(.bold)
            Text("you are doing really great!")
                .font(.title2)
                .fontWeight(.light)
        }
        .padding()
        
        VStack(spacing: 20) {
            HStack(spacing: 20) {
                VStack {
                    Image("awesome")
                        .resizable()
                        .scaledToFit()
                        .padding(.bottom, 5)
                    Text("Awesome")
                        .font(.caption)
                        .fontWeight(.light)
                }
                
                VStack {
                    Image("happy")
                        .resizable()
                        .scaledToFit()
                        .padding(.bottom, 5)
                    Text("Happy")
                        .font(.caption)
                        .fontWeight(.light)
                }
                
                VStack {
                    Image("okay")
                        .resizable()
                        .scaledToFit()
                        .padding(.bottom, 5)
                    Text("Okay")
                        .font(.caption)
                        .fontWeight(.light)
                }
            }
            
            HStack(spacing: 20) {
                VStack {
                    Image("sad")
                        .resizable()
                        .scaledToFit()
                        .padding(.bottom, 5)
                    Text("Sad")
                        .font(.caption)
                        .fontWeight(.light)
                }
                
                VStack {
                    Image("angry")
                        .resizable()
                        .scaledToFit()
                        .padding(.bottom, 5)
                    Text("Angry")
                        .font(.caption)
                        .fontWeight(.light)
                }
                
                VStack {
                    Image("terrible")
                        .resizable()
                        .scaledToFit()
                        .padding(.bottom, 5)
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
        .padding()
    }
}


#Preview {
    StatisticView()
}

