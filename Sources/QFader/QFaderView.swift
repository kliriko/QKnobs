//
//  Fader.swift
//  QKnobs
//
//  Created by Володимир on 25.09.2025.
//

import SwiftUI

public struct QFaderView: View {
    // MARK: - Properties
    @ObservedObject var viewModel: QFaderViewModel
    @Environment(\.faderStyle) private var style
    
    // TODO: REWORK
    private var accessory: ((QFaderViewModel) -> AnyView)?
    private var accessoryAlignment: Alignment
    
    private var minView: ((QFaderViewModel) -> AnyView)?
    private var maxView: ((QFaderViewModel) -> AnyView)?
    private var snapButtonView: ((QFaderViewModel) -> AnyView)?
    
    public init(viewModel: QFaderViewModel = QFaderViewModel()) {
        self.viewModel = viewModel
        self.accessory = nil
        self.accessoryAlignment = .center
        self.minView = nil
        self.maxView = nil
        self.snapButtonView = nil
    }
    
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
    
    // MARK: - Body
    public var body: some View {
        GeometryReader { geo in
            let drag = DragGesture()
                .onChanged { viewModel.handleDragGesture(value: $0) }
                .onEnded { _ in viewModel.handleDragEnd() }

            style.makeBody(
                configuration: QFaderStyleConfiguration(viewModel: viewModel, geometry: geo.size)
            )
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

// MARK: - View Modifiers
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
