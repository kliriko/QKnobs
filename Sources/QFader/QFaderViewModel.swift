//
//  QFaderViewModel.swift
//  QKnobs
//
//  Created by Володимир on 25.09.2025.
//

import SwiftUI
import Combine

#if os(macOS)
import AppKit
#endif

/// ViewModel for the ``QFader``.
/// Handles drag gestures, snapping logic, and maintains normalized position.
public final class QFaderViewModel: ObservableObject, QFaderProtocol {
    public init() { }
    
    @Published public var active: Bool = true
    
    public var feedbackEnabled: Bool = true
    
    // MARK: - Published variables
    
    /// Moves the fader on UI.
    @Published public var offsetY: CGFloat = 0
    
    /// Relative fader position.
    /// This is what tells us the fader's current value. Is in range 0...1.
    @Published public var currentValue: Double = 0.5
    
    /// Determines if fader should snap to its default position.
    @Published public var snapEnabled: Bool = true
    
    @Published public var defaultValue: Double = 0.5
    
    /// Absolute value based on min and max range
    public var absoluteValue: Double {
        get {
            minValue + (currentValue * (maxValue - minValue))
        }
        set {
            currentValue = ((newValue - minValue) / (maxValue - minValue)).clamped(to: 0...1)
        }
    }
    // MARK: - Dimensions
    
    /// Actual width of the fader rectangle.
    var handleWidth: CGFloat = 30
    
    /// Actual height of the fader rectangle.
    var handleHeight: CGFloat = 50
    
    public var trackHeight: CGFloat = 100
    
    // MARK: - Value Range
    
    /// Minimum value of the fader range
    public let minValue: Double = -48
    
    /// Maximum value of the fader range
    public let maxValue: Double = 6
    
    // MARK: - Private properties
    
    /// Offset before dragGesture.
    private var lastOffsetY: CGFloat = 0.0
    
    /// Fader's position to snap towards. Is in range 0...1.
    public let snapValue: Double = 0.5
    
    /// Threshold within which the snap occurs.
    /// > Tip: If the snap value is 0.5 and threshold is 0.05,
    /// > the snap will occur within range 0.45...0.55.
    public var snapThreshold: Double = 0.05

    // MARK: - Gesture Handlers
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
            
            // Trigger haptic feedback
            triggerHapticFeedback()
            
            feedbackEnabled.toggle()
        }
    }
    
    /// Toggles snapping on or off.
    public func toggleSnapping() {
        snapEnabled.toggle()
    }
    
    /// Returns the fader to the snapping point
    public func returnToSnappingPoint() {
        currentValue = snapValue
        offsetY = CGFloat((1 - 2 * snapValue) * trackHeight)
        lastOffsetY = offsetY
    }
    
    // MARK: - Haptic Feedback
    /// Triggers platform-appropriate haptic feedback
    private func triggerHapticFeedback() {
        #if os(macOS)
        NSHapticFeedbackManager.defaultPerformer.perform(.generic, performanceTime: .now)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.03) {
            NSHapticFeedbackManager.defaultPerformer.perform(.generic, performanceTime: .now)
        }
        #elseif os(iOS)
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        #endif
    }
}

