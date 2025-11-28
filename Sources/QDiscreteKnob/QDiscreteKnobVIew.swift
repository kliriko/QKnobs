//
//  SwiftUIView.swift
//  QKnobs
//
//  Created by Володимир on 28.11.2025.
//

import SwiftUI

public struct QDiscreteKnobView: View {
    @ObservedObject var viewModel: QDiscreteKnobViewModel
    
    public init(viewModel: QDiscreteKnobViewModel = QDiscreteKnobViewModel()) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack {
            GeometryReader { geo in
                
                let drag = DragGesture()
                    .onChanged { viewModel.handleDrag(gesture: $0) }
                    .onEnded { _ in
                        viewModel.handleDragEnd()
                    }

                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.2))

                    // Tick marks
                    ForEach(Array(viewModel.allOptions.enumerated()), id: \.offset) { index, option in
                        Rectangle()
                            .fill(Color.gray.opacity(0.6))
                            .frame(width: 3, height: 10)
                            .offset(y: -65)
                            .rotationEffect(.degrees(viewModel.angle(for: option)))
                    }

                    // Current pointer
                    Rectangle()
                        .fill(Color.accentColor)
                        .frame(width: 4, height: 40)
                        .offset(y: -30)
                        .rotationEffect(.degrees(viewModel.angle(for: viewModel.currentSelection)))

                    Circle()
                        .fill(Color.accentColor)
                        .frame(width: 24, height: 24)
                }
                .gesture(drag)
                .frame(width: geo.size.width, height: geo.size.height)
            }
        }
    }
}
