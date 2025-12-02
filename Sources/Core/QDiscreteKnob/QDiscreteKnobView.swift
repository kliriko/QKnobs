//
//  SwiftUIView.swift
//  QKnobs
//
//  Created by Володимир on 28.11.2025.
//

import SwiftUI

/// Knob that allows to switch through the set of options
public struct QDiscreteKnobView: View {
    @Environment(\.discreteKnobStyle) private var style
    @ObservedObject var viewModel: QDiscreteKnobViewModel = QDiscreteKnobViewModel()

    /// Exposed variable that allows customization of knob's labels
    public var labelView: ((Bindable<QDiscreteKnobViewModel>, QDiscreteKnobViewModel.EnumType) -> AnyView)?

    public init() {}

    public var body: some View {
        GeometryReader { geo in
            let drag = DragGesture()
                .onChanged { viewModel.handleDrag(gesture: $0) }
                .onEnded { _ in viewModel.handleDragEnd() }

            ZStack {
                style.makeBody(
                    configuration: QDiscreteKnobStyleConfiguration(
                        viewModel: viewModel,
                        geometry: geo.size
                    )
                )
                .gesture(drag)
                
                if let labelView {
                    let bindable = Bindable(viewModel)

                    ForEach(viewModel.allOptions, id: \.self) { option in
                        labelView(bindable, option)
                            .position(
                                position(
                                    for: option,
                                    radius: min(geo.size.width, geo.size.height) / 2,
                                    in: geo.size
                                )
                            )
                    }
                }
            }
        }
    }
    
    private func position(
        for option: QDiscreteKnobViewModel.EnumType,
        radius: CGFloat,
        in size: CGSize
    ) -> CGPoint {
        let angle = viewModel.angle(for: option) * .pi / 180

        let rad = radius * 0.7

        let xOffset = size.width / 2  + cos(angle) * rad
        let yOffset = size.height / 2 + sin(angle) * rad

        return CGPoint(x: xOffset, y: yOffset)
    }

}

public extension QDiscreteKnobView {
    func knobLabel<Content: View>(
        _ content: @escaping (Bindable<QDiscreteKnobViewModel>, QDiscreteKnobViewModel.EnumType) -> Content
    ) -> Self {
        var copy = self
        copy.labelView = { bindable, option in AnyView(content(bindable, option)) }
        return copy
    }
}
