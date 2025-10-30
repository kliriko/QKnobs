//
//  Fader.swift
//  QKnobs
//
//  Created by Володимир on 25.09.2025.
//

import SwiftUI

/// A vertical fader control with optional snapping and customizable accessory UI.
public struct QFader<Accessory: View>: View {
    // MARK: - Properties
    
    let snappingPoint: Double
    @StateObject private var vm: QFaderViewModel
    
    /// A closure that provides a custom accessory view.
    /// For example, you can use this to add a snapping toggle button or label.
    let accessory: (QFaderViewModel) -> Accessory
    
    /// Alignment for accessory overlay.
    private let overlayAlignment: Alignment

    // MARK: - Initializer
    
    /// Creates a new ``QFader``.
    /// - Parameters:
    ///   - enableSnapping: Whether snapping is enabled initially.
    ///   - snappingPoint: Normalized snapping position (0...1).
    ///   - overlayAlignment: Alignment for the accessory overlay.
    ///   - accessory: Optional view builder providing a custom overlay or control.
    public init(
        enableSnapping: Bool = true,
        snappingPoint: Double = 0.5,
        overlayAlignment: Alignment = .center,
        @ViewBuilder accessory: @escaping (QFaderViewModel) -> Accessory = { _ in EmptyView() }
    ) {
        self.snappingPoint = snappingPoint
        _vm = StateObject(wrappedValue: QFaderViewModel(enableSnapping: enableSnapping, snappingPoint: snappingPoint))
        self.accessory = accessory
        self.overlayAlignment = overlayAlignment
    }
    
    // MARK: - Body
    
    public var body: some View {
        GeometryReader { geo in
            ZStack {
                // Track
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 3)
                    .frame(maxHeight: .infinity)
                
                // --- Snapping Point Indicator Line ---
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
                            .onChanged { value in
                                vm.handleDragGesture(value: value)
                            }
                            .onEnded { _ in
                                vm.handleDragEnd()
                            }
                        
                        
                    )
                    .simultaneousGesture(
                        TapGesture(count: 2)
                            .onEnded {
                                vm.returnToSnappingPoint()
                            }
                    )
                    .animation(.easeInOut(duration: 0.2), value: vm.offsetY)
            }
            .overlay(alignment: overlayAlignment) {
                accessory(vm)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onChange(of: geo.size) { _, new in
                vm.trackHeight = geo.size.height / 2 - vm.handleHeight / 2
            }
            .sensoryFeedback(.success, trigger: vm.snapFeedback)
        }
    }
}
