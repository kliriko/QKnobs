//
//  QFaderViewModel.swift
//  QKnobs
//
//  Created by Володимир on 25.09.2025.
//

import SwiftUI
import Combine

/// ViewModel for the ``QFader``
/// Handles drag gestures, snapping logic, and maintains normalized position
public final class QFaderViewModel: ObservableObject, QContiniousControlProtocol {
    /// Relative fader position.
    /// This is what tells us the fader's current value. Is in range 0...1
    @Published public var currentValue: Double = 0.5
    
    /// Determines if fader should snap to its default position
    @Published public var snapEnabled: Bool = true
    
    /// Relative value for the fader initialization
    @Published public var defaultValue: Double = 0.5
    
    /// Minimum value of the fader range
    @Published public var minValue: Double = -48
    
    /// Maximum value of the fader range
    @Published public var maxValue: Double = 6
    
    /// Fader's position to snap towards. Is in range 0...1
    @Published public var snapValue: Double = 0.5
    
    /// Moves the fader on UI.
    @Published var offsetY: CGFloat = 0
    
    /// Threshold within which the snap occurs
    /// > Tip: If the snap value is 0.5 and threshold is 0.05,
    /// > the snap will occur within range 0.45...0.55
    public var snapThreshold: Double = 0.05
    
    /// Offset before dragGesture.
    private var lastOffsetY: CGFloat = 0.0
    
    /// Actual width of the fader rectangle
    var handleWidth: CGFloat = 30
    
    /// Actual height of the fader rectangle
    var handleHeight: CGFloat = 50
    
    /// Height of the vertical line that appears to 'hold' the fader
    var trackHeight: CGFloat = 100
    
    /// Absolute value based on min and max range
    public var absoluteValue: Double {
        get {
            minValue + (currentValue * (maxValue - minValue))
        }
        set {
            currentValue = ((newValue - minValue) / (maxValue - minValue)).clamped(to: 0...1)
        }
    }
    
    /// Initializes ``QFaderView`` with min, max and default values
    public init(minValue: Double = -48,
                maxValue: Double = 6,
                defaultValue: Double = 0) {
        self.minValue = minValue
        self.maxValue = maxValue
        self.defaultValue = defaultValue
    }
    
    /// Initialized ``QFaderView`` with min, max and default values and snapping params
    public convenience init (minValue: Double = -48,
                             maxValue: Double = 6,
                             defaultValue: Double = 0,
                             snapEnabled: Bool,
                             snapValue: Double,
                             snapThreshold: Double) {
        self.init(minValue: minValue, maxValue: maxValue, defaultValue: defaultValue)
        self.snapEnabled = snapEnabled
        self.snapValue = snapValue
        self.snapThreshold = snapThreshold
    }

    /// Executes when drag occurs in ``QFader``.
    /// - Parameters:
    ///   - currentValue: Return of `DragGesture`.
    public func handleDragGesture(value: DragGesture.Value) {
        let newOffset = lastOffsetY + value.translation.height
        
        let minOffset = -trackHeight
        let maxOffset = trackHeight
        
        offsetY = min(max(newOffset, minOffset), maxOffset)
        
        let normalized = (trackHeight - offsetY) / (2 * trackHeight)
        currentValue = Double(normalized)
    }

    /// Executes when drag ends in ``QFader``.
    public func handleDragEnd() {
        lastOffsetY = offsetY
        
        guard snapEnabled else { return }
        
        // Compute how far we are from the snapping point
        let distance = abs(currentValue - snapValue)
        
        if distance <= snapThreshold {
            // Snap to target position
            currentValue = snapValue
            
            // Convert normalized value back to offsetY
            offsetY = CGFloat((1 - 2 * snapValue) * trackHeight)
            lastOffsetY = offsetY
        }
    }
    
    /// Toggles snapping
    public func toggleSnapping() {
        snapEnabled.toggle()
    }
    
    /// Returns the fader to the snapping point
    public func returnToSnappingPoint() {
        currentValue = snapValue
        offsetY = CGFloat((1 - 2 * snapValue) * trackHeight)
        lastOffsetY = offsetY
    }
}
