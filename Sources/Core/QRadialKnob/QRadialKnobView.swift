//
//  QRadialKnobView.swift
//  QKnobs
//

import SwiftUI

public struct QRadialKnobView: View {
    @Environment(\.radialKnobStyle) private var style
    @ObservedObject private var viewModel: QRadialKnobViewModel

    // Inject custom UI
    public var minView: ((Bindable<QRadialKnobViewModel>) -> AnyView)?
    public var maxView: ((Bindable<QRadialKnobViewModel>) -> AnyView)?
    public var valueView: ((Bindable<QRadialKnobViewModel>) -> AnyView)?
    public var snapButtonView: ((Bindable<QRadialKnobViewModel>) -> AnyView)?

    public init(viewModel: QRadialKnobViewModel = QRadialKnobViewModel()) {
        self.viewModel = viewModel
    }
    
    public init(minValue: Double = 0,
                maxValue: Double = 11,
                defaultValue: Double = 0.5) {
        self.viewModel = QRadialKnobViewModel(minValue: minValue, maxValue: maxValue, defaultValue: defaultValue)
    }
    
    public init (minValue: Double = 0,
                 maxValue: Double = 11,
                 defaultValue: Double = 0.5,
                 snapEnabled: Bool,
                 snapValue: Double,
                 snapThreshold: Double) {
        self.viewModel = QRadialKnobViewModel(minValue: minValue, maxValue: maxValue, defaultValue: defaultValue,
                          snapEnabled: snapEnabled, snapValue: snapValue, snapThreshold: snapThreshold)
    }

    public var body: some View {
        ZStack {
            GeometryReader { geo in
                let dragGesture = DragGesture()
                    .onChanged { viewModel.handleDrag(gesture: $0) }
                    .onEnded { _ in
                        viewModel.handleDragEnd()
                    }

                ZStack {
                    style.makeBody(
                        configuration: .init(
                            viewModel: viewModel,
                            geometry: geo.size
                        )
                    )
                    
                    let bindable = Bindable(viewModel)
                    if let minView { minView(bindable) }
                    if let maxView { maxView(bindable) }
                    if let valueView { valueView(bindable) }
                    if let snapButtonView { snapButtonView(bindable) }
                }
                .frame(width: geo.size.width, height: geo.size.height)
                .gesture(dragGesture)
                .onTapGesture(count: 2) {
                    viewModel.reset()
                }
            }
        }
    }
}

// MARK: - Modifiers
public extension QRadialKnobView {
    func knobMinView<Content: View>(
        _ content: @escaping (Bindable<QRadialKnobViewModel>) -> Content
    ) -> Self {
        var copy = self
        copy.minView = { viewModel in AnyView(content(viewModel)) }
        return copy
    }

    func knobMaxView<Content: View>(
        _ content: @escaping (Bindable<QRadialKnobViewModel>) -> Content
    ) -> Self {
        var copy = self
        copy.maxView = { viewModel in AnyView(content(viewModel)) }
        return copy
    }

    func knobValueView<Content: View>(
        _ content: @escaping (Bindable<QRadialKnobViewModel>) -> Content
    ) -> Self {
        var copy = self
        copy.valueView = { viewModel in AnyView(content(viewModel)) }
        return copy
    }

    func knobAccessory<Content: View>(
        _ content: @escaping (Bindable<QRadialKnobViewModel>) -> Content
    ) -> Self {
        var copy = self
        copy.snapButtonView = { viewModel in AnyView(content(viewModel)) }
        return copy
    }
}

#Preview {
    QRadialKnobView()
        .frame(width: 50, height: 50)
}
