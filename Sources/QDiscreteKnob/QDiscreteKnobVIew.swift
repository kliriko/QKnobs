//
//  SwiftUIView.swift
//  QKnobs
//
//  Created by Володимир on 28.11.2025.
//

import SwiftUI

public struct QDiscreteKnobView: View {
    @ObservedObject var viewModel: QDiscreteKnobViewModel

    public var labelView: ((Bindable<QDiscreteKnobViewModel>, QDiscreteKnobViewModel.EnumType) -> AnyView)?
    
    public init(viewModel: QDiscreteKnobViewModel = QDiscreteKnobViewModel()) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack {
            GeometryReader { geo in
                
                let drag = DragGesture()
                    .onChanged { viewModel.handleDrag(gesture: $0) }
                    .onEnded { _ in viewModel.handleDragEnd() }

                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.2))

                    // Tick marks
                    ForEach(Array(viewModel.allOptions.enumerated()), id: \.offset) { _, option in
                        Rectangle()
                            .fill(Color.gray.opacity(0.6))
                            .frame(width: 3, height: 10)
                            .offset(y: -65)
                            .rotationEffect(.degrees(viewModel.angle(for: option)))
                    }
                    
                    let bindable = Bindable(viewModel)

                    ForEach(Array(viewModel.allOptions.enumerated()), id: \.offset) { _, option in
                        // tick
                        Rectangle()
                            .fill(Color.gray.opacity(0.5))
                            .frame(width: 3, height: 10)
                            .offset(y: -65)
                            .rotationEffect(.degrees(viewModel.angle(for: option)))

                        if let labelView = labelView {
                            labelView(bindable, option)
                                .offset(y: -95)
                                .rotationEffect(.degrees(-viewModel.angle(for: option)))
                        }
                    }
                    .onChange(of: viewModel.currentSelection) { _ in
                        print(viewModel.currentSelection.rawValue)
                    }

                    Rectangle()
                        .fill(Color.accentColor)
                        .frame(width: 4, height: 40)
                        .offset(y: -30)
                        .rotationEffect(.degrees(-viewModel.angle(for: viewModel.currentSelection)))

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

public extension QDiscreteKnobView {
    func knobLabel<Content: View>(
        _ content: @escaping (Bindable<QDiscreteKnobViewModel>, QDiscreteKnobViewModel.EnumType) -> Content
    ) -> Self {
        var copy = self
        copy.labelView = { viewModel, option in AnyView(content(viewModel, option)) }
        return copy
    }
}
