//
//  Fader.swift
//  QKnobs
//
//  Created by Володимир on 25.09.2025.
//

import SwiftUI

/// Fader that mimic ones found on the mixer. Basically a vertical slider with tweakable
/// min and max values. Supports snapping at a desired position
public struct QFaderView: View {
    @ObservedObject var viewModel: QFaderViewModel
    @Environment(\.faderStyle) private var style
    
    // TODO: REWORK
    private var accessory: ((QFaderViewModel) -> AnyView)?
    private var accessoryAlignment: Alignment
    
    private var minView: ((QFaderViewModel) -> AnyView)?
    private var maxView: ((QFaderViewModel) -> AnyView)?
    private var snapButtonView: ((QFaderViewModel) -> AnyView)?
    
    /// Creates a Fader with basic parameters
    public init(viewModel: QFaderViewModel = QFaderViewModel()) {
        self.accessory = nil
        self.accessoryAlignment = .center
        self.minView = nil
        self.maxView = nil
        self.snapButtonView = nil
        self.viewModel = viewModel
    }
    
    /// Creates a fader with the abiity to set min, max and default values
    public init (viewModel: QFaderViewModel = QFaderViewModel(),
                 minValue: Double = -48,
                 maxValue: Double = 6,
                 defaultValue: Double = 0) {
        self.init(viewModel: viewModel)
        self.viewModel.minValue = minValue
        self.viewModel.maxValue = maxValue
        self.viewModel.defaultValue = defaultValue
    }
    /// Creates fader with the ability to modify min, max, default values and snap params
    public init (viewModel: QFaderViewModel = QFaderViewModel(),
                 minValue: Double = -48,
                 maxValue: Double = 6,
                 defaultValue: Double = 0,
                 snapEnabled: Bool,
                 snapValue: Double,
                 snapThreshold: Double) {
        self.init(viewModel: viewModel, minValue: minValue, maxValue: maxValue, defaultValue: defaultValue)
        self.viewModel.snapEnabled = snapEnabled
        self.viewModel.snapValue = snapValue
        self.viewModel.snapThreshold = snapThreshold
    }
    
    /// Initializes view modifiers for the ``QFaderView``
    private init(
        viewModel: QFaderViewModel,
        accessory: ((QFaderViewModel) -> AnyView)?,
        accessoryAlignment: Alignment,
        minView: ((QFaderViewModel) -> AnyView)?,
        maxView: ((QFaderViewModel) -> AnyView)?,
        snapButtonView: ((QFaderViewModel) -> AnyView)?
    ) {
        self.viewModel = viewModel
        self.accessory = accessory
        self.accessoryAlignment = accessoryAlignment
        self.minView = minView
        self.maxView = maxView
        self.snapButtonView = snapButtonView
    }
    
    public var body: some View {
        GeometryReader { geo in
            let drag = DragGesture()
                .onChanged { viewModel.handleDragGesture(value: $0) }
                .onEnded { _ in viewModel.handleDragEnd() }

            ZStack {
                style.makeBody(
                    configuration: QFaderStyleConfiguration(viewModel: viewModel, geometry: geo.size)
                )

                if let minView {
                    minView(viewModel)
                }

                if let maxView {
                    maxView(viewModel)
                }

                if let accessory {
                    accessory(viewModel)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: accessoryAlignment)
                }

                if let snapButtonView {
                    snapButtonView(viewModel)
                    
                }
            }
            .gesture(drag)
            .simultaneousGesture(
                TapGesture(count: 2).onEnded { viewModel.returnToSnappingPoint() }
            )
            .onChange(of: geo.size) { _, new in
                viewModel.trackHeight = new.height / 2 - viewModel.handleHeight / 2
                viewModel.returnToSnappingPoint()
            }
        }
    }

}

public extension QFaderView {
    func accessoryView<Content: View>(
        alignment: Alignment = .center,
        @ViewBuilder _ content: @escaping (QFaderViewModel) -> Content
    ) -> QFaderView {
        .init(
            viewModel: viewModel,
            accessory: { AnyView(content($0)) },
            accessoryAlignment: alignment,
            minView: minView,
            maxView: maxView,
            snapButtonView: snapButtonView
        )
    }
    
    func minView<MinV: View>(
        @ViewBuilder _ content: @escaping (QFaderViewModel) -> MinV
    ) -> QFaderView {
        .init(
            viewModel: viewModel,
            accessory: accessory,
            accessoryAlignment: accessoryAlignment,
            minView: { AnyView(content($0)) },
            maxView: maxView,
            snapButtonView: snapButtonView
        )
    }
    
    func maxView<MaxV: View>(
        @ViewBuilder _ content: @escaping (QFaderViewModel) -> MaxV
    ) -> QFaderView {
        .init(
            viewModel: viewModel,
            accessory: accessory,
            accessoryAlignment: accessoryAlignment,
            minView: minView,
            maxView: { AnyView(content($0)) },
            snapButtonView: snapButtonView
        )
    }
    
    func faderSnapButton<Content: View>(
        @ViewBuilder _ content: @escaping (QFaderViewModel) -> Content
    ) -> QFaderView {
        .init(
            viewModel: viewModel,
            accessory: accessory,
            accessoryAlignment: accessoryAlignment,
            minView: minView,
            maxView: maxView,
            snapButtonView: { AnyView(content($0)) }
        )
    }
}

#Preview {
    QFaderView()
}
