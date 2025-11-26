//
//  QRadialKnobView.swift
//  QKnobs
//

import SwiftUI

public struct QRadialKnobView: View {

    @StateObject private var viewModel = QRadialKnobViewModel()

    // Inject custom UI
    public var minView: ((Bindable<QRadialKnobViewModel>) -> AnyView)?
    public var maxView: ((Bindable<QRadialKnobViewModel>) -> AnyView)?
    public var valueView: ((Bindable<QRadialKnobViewModel>) -> AnyView)?
    public var accessoryView: ((Bindable<QRadialKnobViewModel>) -> AnyView)?

    public init() {}

    public var body: some View {
        ZStack {
            GeometryReader { geo in
                
                let drag = DragGesture()
                    .onChanged { viewModel.handleDrag(gesture: $0) }
                    .onEnded { _ in
                        viewModel.handleDragEnd()
                        viewModel.startValue = nil
                    }

                ZStack {
                    // --- Base Circular Knob ---
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .shadow(radius: 4)
                        .gesture(drag)

                    // Default reference position
                    Rectangle()
                        .fill(Color.secondary)
                        .frame(width: 3, height: 18)
                        .offset(y: -60)
                        .rotationEffect(.degrees(viewModel.defaultAngle))

                    // Current angle pointer
                    Rectangle()
                        .fill(Color.accentColor)
                        .frame(width: 4, height: 40)
                        .offset(y: -30)
                        .rotationEffect(.degrees(viewModel.angle))

                    // Center cap
                    Circle()
                        .fill(Color.accentColor)
                        .frame(width: 24, height: 24)

                    // --- Optional UI extensions ---
                    let bindable = Bindable(viewModel)

                    if let minView { minView(bindable) }
                    if let maxView { maxView(bindable) }
                    if let valueView { valueView(bindable) }
                    if let accessoryView { accessoryView(bindable) }
                }
                .frame(width: geo.size.width, height: geo.size.height)
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
        copy.minView = { vm in AnyView(content(vm)) }
        return copy
    }

    func knobMaxView<Content: View>(
        _ content: @escaping (Bindable<QRadialKnobViewModel>) -> Content
    ) -> Self {
        var copy = self
        copy.maxView = { vm in AnyView(content(vm)) }
        return copy
    }

    func knobValueView<Content: View>(
        _ content: @escaping (Bindable<QRadialKnobViewModel>) -> Content
    ) -> Self {
        var copy = self
        copy.valueView = { vm in AnyView(content(vm)) }
        return copy
    }

    func knobAccessory<Content: View>(
        _ content: @escaping (Bindable<QRadialKnobViewModel>) -> Content
    ) -> Self {
        var copy = self
        copy.accessoryView = { vm in AnyView(content(vm)) }
        return copy
    }
}

#Preview {
    QRadialKnobView()
}
