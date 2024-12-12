//
//  CustomTabBar.swift
//  CloudMemo
//
//  Created by Gizem Coskun on 10/12/24.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack {
            Spacer()
            TabBarButton(title: "Home", icon: "house", tag: 0, selectedTab: $selectedTab)
            Spacer()
            TabBarButton(title: "Search", icon: "magnifyingglass", tag: 1, selectedTab: $selectedTab)
            Spacer()
            TabBarButton(title: "Profile", icon: "person", tag: 2, selectedTab: $selectedTab)
            Spacer()
        }
        .padding(.vertical, 10)
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: -5)
    }
}

struct TabBarButton: View {
    let title: String
    let icon: String
    let tag: Int
    @Binding var selectedTab: Int
    
    var body: some View {
        Button(action: { selectedTab = tag }) {
            VStack {
                Image(systemName: icon)
                    .font(.system(size: 24))
                Text(title)
                    .font(.caption)
            }
            .foregroundColor(selectedTab == tag ? .blue : .gray)
        }
    }
}
