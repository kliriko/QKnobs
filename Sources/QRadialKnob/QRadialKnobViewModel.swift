//
//  QRadialKnobViewModel.swift
//  QKnobs
//
//  Created by Володимир on 25.11.2025.
//

import Foundation
import SwiftUI

final class QRadialKnobViewModel: ObservableObject, QRadialKnobProtocol {
    func getAbsoluteValue() -> Double {
        absoluteValue(for: currentValue)
    }
    
    // MARK: - Angles
    var minAngle: Double = -135
    var maxAngle: Double = 135
    
    // MARK: - Values
    @Published var defaultValue: Double = 0.5
    @Published var currentValue: Double = 0
    @Published var minValue: Double = 0
    @Published var maxValue: Double = 11
    
    // MARK: - Snap & Feedback
    @Published var active: Bool = true
    @Published var snapEnabled: Bool = true
    @Published var snapValue: Double = 0.5
    @Published var snapThreshold: Double = 0.1
    @Published var feedbackEnabled: Bool = true
    
    /// Starting normalized value during drag
    var startValue: Double?
    
    // MARK: - Value Mapping
    
    func absoluteValue(for normalized: Double) -> Double {
        normalized.qknobClamped(to: 0...1) * (maxValue - minValue) + minValue
    }
    
    func angle(for normalized: Double) -> Double {
        normalized.qknobClamped(to: 0...1) * (maxAngle - minAngle) + minAngle
    }
    
    var currentAbsoluteValue: Double { absoluteValue(for: currentValue) }
    var currentAngle: Double { angle(for: currentValue) }
    var defaultAngle: Double { angle(for: defaultValue) }
    
    // MARK: - Safe Setters
    
    func setCurrentValue(_ value: Double) {
        currentValue = value.qknobClamped(to: 0...1)
    }
    
    func setDefaultValue(_ value: Double) {
        defaultValue = value.qknobClamped(to: 0...1)
    }
    
    func setSnapValue(_ value: Double) {
        snapValue = value.qknobClamped(to: 0...1)
    }
    
    // MARK: - Gestures
    func handleDrag(gesture: DragGesture.Value) {
        if startValue == nil {
            startValue = currentValue
        }
        
        let dragAmount = -(gesture.translation.height / 150.0)
        let base = startValue ?? 0
        
        setCurrentValue(base + dragAmount)
    }
    
    func handleDragEnd() {
        startValue = nil
        if snapEnabled {
            let dist = abs(currentValue - snapValue)
            if dist < snapThreshold {
                setCurrentValue(snapValue)
            }
        }
    }
}

public extension Comparable {
    func qknobClamped(to limits: ClosedRange<Self>) -> Self {
        min(max(self, limits.lowerBound), limits.upperBound)
    }
}
