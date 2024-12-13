//
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
            VStack(spacing: 10) {
                Image(systemName: "checkmark.icloud.fill")
                    .font(.system(size: 50))
                
                Text("Another journal entry down!")
                    .multilineTextAlignment(.center)
                    .font(.caption)
            }
        }
        .animation(animation, value: drawingStroke)
        .padding(70)
        .onAppear {
            drawingStroke.toggle()
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func ring(for color: Color) -> some View {
        Circle()
            .stroke(style: StrokeStyle(lineWidth: 16))
            .foregroundStyle(.tertiary)
            .overlay {
                Circle()
                    .trim(from: 0, to: drawingStroke ? 1 : 0)
                    .stroke(color.gradient,
                            style: StrokeStyle(lineWidth: 16, lineCap: .round))
            }
            .rotationEffect(.degrees(-90))
    }
}

#Preview {
    CircleComplete(selectedColor: .green)
}
