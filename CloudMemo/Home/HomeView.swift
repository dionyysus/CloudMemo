//
//  HomeView.swift
//  CloudMemo
//
//  Created by Gizem Coskun on 10/12/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Image(systemName: "cloud.fill")
                .font(.largeTitle)
                .foregroundColor(.black)
                .padding()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    HomeView()
}
