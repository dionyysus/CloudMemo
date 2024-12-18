//  CircleComplete.swift
//  CloudMemo
//
//  Created by Gizem Coskun on 11/12/24.
//

import SwiftUI

struct CircleComplete: View {
    @State private var drawingStroke = false
    
    let selectedColor: Color
    
    let animation = Animation
        .easeOut(duration: 1)
        .delay(0.1)
    
    var body: some View {
        ZStack {
            ring(for: selectedColor)
            
            VStack(spacing: 5) {
                Image(systemName: "checkmark.icloud.fill")
                    .font(.system(size: 40))
                    .foregroundColor(selectedColor)
                
                Text("Journal entry complete!")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(40)
        .animation(animation, value: drawingStroke)
        .onAppear {
            drawingStroke.toggle()
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func ring(for color: Color) -> some View {
        Circle()
            .stroke(style: StrokeStyle(lineWidth: 12))
            .foregroundColor(Color.gray.opacity(0.2))
            .overlay {
                Circle()
                    .trim(from: 0, to: drawingStroke ? 1 : 0)
                    .stroke(color.gradient,
                            style: StrokeStyle(lineWidth: 12, lineCap: .round))
            }
            .rotationEffect(.degrees(-90))
    }
}

#Preview {
    CircleComplete(selectedColor: .green)
}
