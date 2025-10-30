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
public final class QFaderViewModel: ObservableObject {
    // MARK: - Published variables
    
    /// Moves the fader on UI.
    @Published public var offsetY: CGFloat = 0
    
    /// Relative fader position.
    /// This is what tells us the fader's current value. Is in range 0...1.
    @Published public var relativePosition: Double = 0.5
    
    /// Determines if fader should snap to its default position.
    @Published public var enableSnapping: Bool
    
    @Published internal var snapFeedback: Bool = false
    
    // MARK: - Dimensions
    
    /// Actual width of the fader rectangle.
    internal var handleWidth: CGFloat = 30
    
    /// Actual height of the fader rectangle.
    internal var handleHeight: CGFloat = 50
    
    internal var trackHeight: CGFloat = 100
    
    // MARK: - Private properties
    
    /// Offset before dragGesture.
    private var lastOffsetY: CGFloat = 0.0
    
    /// Fader's position to snap towards. Is in range 0...1.
    private let snappingPoint: Double
    
    /// Threshold within which the snap occurs.
    /// > Tip: If the snap value is 0.5 and threshold is 0.05,
    /// > the snap will occur within range 0.45...0.55.
    private let snappingThreshold: Double

    // MARK: - Initializers
    
    /// Initializes a new instance of ``QFaderViewModel``.
    /// - Parameters:
    ///   - enableSnapping: Whether snapping is enabled.
    ///   - snappingPoint: Normalized position to snap to.
    ///   - snappingThreshold: Range around the snapping point to trigger snapping.
    public init(enableSnapping: Bool, snappingPoint: Double, snappingThreshold: Double = 0.05) {
        self.enableSnapping = enableSnapping
        self.snappingPoint = snappingPoint
        self.snappingThreshold = snappingThreshold
        self.relativePosition = snappingPoint
        
        returnToSnappingPoint()
    }

    // MARK: - Gesture Handlers
    
    /// Executes when drag occurs in ``QFader``.
    /// - Parameters:
    ///   - value: Return of `DragGesture`.
    ///   - travelLimit: Limitation for fader movement.
    public func handleDragGesture(value: DragGesture.Value) {
        let newOffset = lastOffsetY + value.translation.height
        
        let minOffset = -trackHeight
        let maxOffset = trackHeight
        
        offsetY = min(max(newOffset, minOffset), maxOffset)
        
        let normalized = (trackHeight - offsetY) / (2 * trackHeight)
        relativePosition = Double(normalized)
    }

    /// Executes when drag ends in ``QFader``.
    /// - Parameters:
    ///   - travelLimit: Limitation for fader movement.
    public func handleDragEnd() {
        lastOffsetY = offsetY
        
        guard enableSnapping else { return }
        
        // Compute how far we are from the snapping point
        let distance = abs(relativePosition - snappingPoint)
        
        if distance <= snappingThreshold {
            // Snap to target position
            relativePosition = snappingPoint
            
            // Convert normalized value back to offsetY
            offsetY = CGFloat((1 - 2 * snappingPoint) * trackHeight)
            lastOffsetY = offsetY
            
            // Trigger haptic feedback
            triggerHapticFeedback()
            
            snapFeedback.toggle()
            print(snapFeedback)
            print("Snapped to \(snappingPoint)")
        }
    }
    
    /// Toggles snapping on or off.
    public func toggleSnapping() {
        enableSnapping.toggle()
    }
    
    /// Returns the fader to the snapping point
    public func returnToSnappingPoint() {
        relativePosition = snappingPoint
        offsetY = CGFloat((1 - 2 * snappingPoint) * trackHeight)
        lastOffsetY = offsetY
    }
    
    // MARK: - Haptic Feedback
    
    /// Triggers platform-appropriate haptic feedback
    private func triggerHapticFeedback() {
            #if os(macOS)
            // Double impact for stronger initial feedback
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
