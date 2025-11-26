//
//  QRadialKnobView.swift
//  QKnobs
//
//  Created by Володимир on 25.11.2025.
//

import SwiftUI

struct QRadialKnobView: View {
    @StateObject private var viewModel = QRadialKnobViewModel()
    
    var body: some View {
        let drag = DragGesture()
            .onChanged { gesture in
                viewModel.handleDrag(gesture: gesture)
            }
            .onEnded { _ in
                viewModel.handleDragEnd()
            }
        
        ZStack {
            Circle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 100, height: 100)
                .shadow(radius: 4)
            
            // Default mark
            Rectangle()
                .fill(Color.secondary)
                .frame(width: 3, height: 18)
                .offset(y: -60)
                .rotationEffect(.degrees(viewModel.defaultAngle))
            
            // Active pointer
            Rectangle()
                .fill(Color.accentColor)
                .frame(width: 4, height: 40)
                .offset(y: -30)
                .rotationEffect(.degrees(viewModel.currentAngle))
            
            Circle()
                .fill(Color.accentColor)
                .frame(width: 24, height: 24)
        }
        .padding(20)
        .gesture(drag)
        .onTapGesture(count: 2) {
            withAnimation(.spring()) {
                viewModel.setCurrentValue(viewModel.defaultValue)
            }
        }
    }
}

#Preview {
    QRadialKnobView()
}
