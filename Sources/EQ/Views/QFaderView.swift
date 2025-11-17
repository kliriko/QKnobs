//
//  Fader.swift
//  QKnobs
//
//  Created by Володимир on 25.09.2025.
//

import SwiftUI

public struct QFader: View {

    // MARK: - Properties

    let snappingPoint: Double
    @StateObject private var vm: QFaderViewModel

    // Optional overlays
    private var accessory: ((QFaderViewModel) -> AnyView)?
    private var accessoryAlignment: Alignment

    private var minView: ((QFaderViewModel) -> AnyView)?
    private var maxView: ((QFaderViewModel) -> AnyView)?
    private var snapButtonView: ((QFaderViewModel) -> AnyView)?

    // MARK: - Public Init

    public init(
        enableSnapping: Bool = true,
        snappingPoint: Double = 0.5,
        minValue: Double = 0.0,
        maxValue: Double = 1.0
    ) {
        self.snappingPoint = snappingPoint
        _vm = StateObject(wrappedValue: QFaderViewModel(
            enableSnapping: enableSnapping,
            snappingPoint: snappingPoint,
            minValue: minValue,
            maxValue: maxValue
        ))
        self.accessory = nil
        self.accessoryAlignment = .center
        self.minView = nil
        self.maxView = nil
        self.snapButtonView = nil
    }

    // MARK: - Private Chaining Init

    private init(
        snappingPoint: Double,
        vm: StateObject<QFaderViewModel>,
        accessory: ((QFaderViewModel) -> AnyView)?,
        accessoryAlignment: Alignment,
        minView: ((QFaderViewModel) -> AnyView)?,
        maxView: ((QFaderViewModel) -> AnyView)?,
        snapButtonView: ((QFaderViewModel) -> AnyView)?
    ) {
        self.snappingPoint = snappingPoint
        self._vm = vm
        self.accessory = accessory
        self.accessoryAlignment = accessoryAlignment
        self.minView = minView
        self.maxView = maxView
        self.snapButtonView = snapButtonView
    }

    // MARK: - Body

    public var body: some View {
        GeometryReader { geo in
            ZStack {
                // Track line
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 3)
                    .frame(maxHeight: .infinity)

                // Snap indicator
                let snapY = (1 - snappingPoint) * (2 * vm.trackHeight) - vm.trackHeight
                Rectangle()
                    .fill(vm.enableSnapping ? Color.gray.opacity(0.5) : Color.gray.opacity(0.3))
                    .frame(height: 2)
                    .frame(maxWidth: .infinity)
                    .offset(y: snapY)
                    .allowsHitTesting(false)

                // Handle
                Rectangle()
                    .fill(Color.blue)
                    .overlay(
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: max(vm.handleWidth - 8, 0), height: 2)
                            .position(x: vm.handleWidth / 2, y: vm.handleHeight / 2)
                    )
                    .frame(width: vm.handleWidth, height: vm.handleHeight)
                    .offset(y: vm.offsetY)
                    .gesture(
                        DragGesture()
                            .onChanged { vm.handleDragGesture(value: $0) }
                            .onEnded { _ in vm.handleDragEnd() }
                    )
                    .simultaneousGesture(
                        TapGesture(count: 2).onEnded { vm.returnToSnappingPoint() }
                    )
                    .animation(.easeInOut(duration: 0.2), value: vm.offsetY)

                // -------------------------------
                // EXACT POSITION MIN/MAX/SNAP UI
                // -------------------------------

                if let minView = minView {
                    minView(vm)
                        .offset(y: vm.trackHeight)
                }

                if let maxView = maxView {
                    maxView(vm)
                        .offset(y: -vm.trackHeight)
                }

                if let snapBtn = snapButtonView {
                    snapBtn(vm)
                        .offset(y: snapY)
                }
            }
            .overlay(alignment: accessoryAlignment) {
                if let accessory = accessory {
                    accessory(vm)
                }
            }
            .onChange(of: geo.size) { _, new in
                vm.trackHeight = new.height / 2 - vm.handleHeight / 2
                vm.returnToSnappingPoint()
            }
            .sensoryFeedback(.success, trigger: vm.snapFeedback)
        }
    }
}

// MARK: - View Modifiers

public extension QFader {
    func accessoryView<Content: View>(
        alignment: Alignment = .center,
        @ViewBuilder _ content: @escaping (QFaderViewModel) -> Content
    ) -> QFader {
        .init(
            snappingPoint: snappingPoint,
            vm: _vm,
            accessory: { AnyView(content($0)) },
            accessoryAlignment: alignment,
            minView: minView,
            maxView: maxView,
            snapButtonView: snapButtonView
        )
    }

    func minView<MinV: View>(
        @ViewBuilder _ content: @escaping (QFaderViewModel) -> MinV
    ) -> QFader {
        .init(
            snappingPoint: snappingPoint,
            vm: _vm,
            accessory: accessory,
            accessoryAlignment: accessoryAlignment,
            minView: { AnyView(content($0)) },
            maxView: maxView,
            snapButtonView: snapButtonView
        )
    }

    func maxView<MaxV: View>(
        @ViewBuilder _ content: @escaping (QFaderViewModel) -> MaxV
    ) -> QFader {
        .init(
            snappingPoint: snappingPoint,
            vm: _vm,
            accessory: accessory,
            accessoryAlignment: accessoryAlignment,
            minView: minView,
            maxView: { AnyView(content($0)) },
            snapButtonView: snapButtonView
        )
    }

    func faderSnapButton<Content: View>(
        @ViewBuilder _ content: @escaping (QFaderViewModel) -> Content
    ) -> QFader {
        .init(
            snappingPoint: snappingPoint,
            vm: _vm,
            accessory: accessory,
            accessoryAlignment: accessoryAlignment,
            minView: minView,
            maxView: maxView,
            snapButtonView: { AnyView(content($0)) }
        )
    }
}
