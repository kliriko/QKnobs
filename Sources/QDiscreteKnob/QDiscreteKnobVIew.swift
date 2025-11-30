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

    @Environment(\.discreteKnobStyle)
    private var style

    public init(viewModel: QDiscreteKnobViewModel = QDiscreteKnobViewModel()) {
        self.viewModel = viewModel
    }

    public var body: some View {
        GeometryReader { geo in
            let drag = DragGesture()
                .onChanged { viewModel.handleDrag(gesture: $0) }
                .onEnded { _ in viewModel.handleDragEnd() }

            style.makeBody(
                configuration: QDiscreteKnobStyleConfiguration(
                    viewModel: viewModel,
                    geometry: geo.size
                )
            )
            .gesture(drag)
        }
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
