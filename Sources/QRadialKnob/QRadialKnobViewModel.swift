//
//  QRadialKnobViewModel.swift
//  QKnobs
//
//  Created by Володимир on 25.11.2025.
//

import SwiftUI

public final class QRadialKnobViewModel: ObservableObject, Observable, QRadialKnobProtocol {
    // MARK: - QControl
    @Published public var active: Bool = true
    @Published public var currentValue: Double  // 0…1
    @Published public var defaultValue: Double  // 0…1

    @Published public var minValue: Double
    @Published public var maxValue: Double

    @Published public var snapEnabled: Bool = true
    @Published public var snapValue: Double  // 0…1
    @Published public var snapThreshold: Double = 0.05  // in 0…1 normalized units
    @Published public var feedbackEnabled: Bool = true

    // MARK: - QRadialKnobProtocol
    public var minAngle: Double = -135
    public var maxAngle: Double = 135

    // MARK: - Internal drag state
    public var startValue: Double?

    // MARK: - Init
    public init(
        minValue: Double = 0,
        maxValue: Double = 11,
        defaultValue: Double = 0.5
    ) {
        self.minValue = minValue
        self.maxValue = maxValue
        self.defaultValue = defaultValue.clamped(to: 0...1)
        self.currentValue = defaultValue
        self.snapValue = defaultValue
    }

    // MARK: - Helpers

    /// Absolute value for display: maps 0…1 -> min…max
    public var absoluteValue: Double {
        get {
            minValue + (currentValue * (maxValue - minValue))
        }
        set {
            currentValue = ((newValue - minValue) / (maxValue - minValue)).clamped(to: 0...1)
        }
    }

    /// Angle for display: maps 0…1 -> minAngle…maxAngle
    public var angle: Double {
        minAngle + currentValue * (maxAngle - minAngle)
    }

    public var defaultAngle: Double {
        minAngle + defaultValue * (maxAngle - minAngle)
    }

    public func setCurrentValue(_ val: Double) {
        currentValue = val.clamped(to: 0...1)
    }

    // MARK: - Drag Handling
    public func handleDrag(gesture: DragGesture.Value) {
        if startValue == nil { startValue = currentValue }

        let dragDelta = -gesture.translation.height / 150
        let newValue = (startValue ?? 0) + dragDelta

        setCurrentValue(newValue)
    }

    public func handleDragEnd() {
        if snapEnabled,
           abs(currentValue - snapValue) < snapThreshold {
            currentValue = snapValue
        }
    }
    
    public func reset() {
        setCurrentValue(defaultValue)
    }
}

public extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
