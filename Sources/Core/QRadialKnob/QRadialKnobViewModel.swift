//
//  QRadialKnobViewModel.swift
//  QKnobs
//
//  Created by Володимир on 25.11.2025.
//

import SwiftUI

/// ViewModel for the ``QRadialKnob``
///
/// Responsible for:
/// - Maintaining normalized knob value (0…1)
/// - Mapping value to angles
/// - Handling drag gestures
/// - Applying snapping behavior (detents)
/// - Converting between absolute and normalized ranges
///
/// This ViewModel is analogous to `QFaderViewModel`, but for rotational controls.
public final class QRadialKnobViewModel: ObservableObject, Observable, QRadialKnobProtocol {
    /// Determines if the control is interactive and visually active.
    @Published public var active: Bool = true

    /// Normalized knob value in range **0…1**.
    /// This drives the knob angle and the actual absolute value.
    @Published public var currentValue: Double

    /// Default normalized value (0…1).
    /// Used for resetting or snapping behavior.
    @Published public var defaultValue: Double

    /// Minimum absolute value of the knob.
    @Published public var minValue: Double

    /// Maximum absolute value of the knob.
    @Published public var maxValue: Double

    /// Enables snapping behavior while dragging.
    @Published public var snapEnabled: Bool = true

    /// Snap target position in normalized units (0…1).
    @Published public var snapValue: Double

    /// Threshold around the snap target within which snapping occurs.
    /// For example, threshold `0.05` makes the range:
    /// `snapValue - 0.05 ... snapValue + 0.05`
    @Published public var snapThreshold: Double = 0.05

    /// Enables or disables haptic feedback.
    @Published public var feedbackEnabled: Bool = true

    /// Minimum allowed angle (in degrees).
    /// Usually negative, e.g. **–135°**.
    public var minAngle: Double = -135

    /// Maximum allowed angle (in degrees).
    /// Usually positive, e.g. **135°**.
    public var maxAngle: Double = 135

    /// Stores the `currentValue` when drag begins.
    /// Used to calculate the delta while dragging.
    private var startValue: Double?

    /// Initializes a radial knob with absolute min/max values and a default normalized value.
    /// - Parameters:
    ///   - minValue: Minimum absolute value.
    ///   - maxValue: Maximum absolute value.
    ///   - defaultValue: Initial normalized value in **0…1**.
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

    /// Initializes a radial knob with snapping configuration.
    /// - Parameters:
    ///   - snapEnabled: Enables snapping.
    ///   - snapValue: The target normalized snap point.
    ///   - snapThreshold: Allowed distance to snap.
    public convenience init(
        minValue: Double = 0,
        maxValue: Double = 11,
        defaultValue: Double = 0.5,
        snapEnabled: Bool,
        snapValue: Double,
        snapThreshold: Double
    ) {
        self.init(minValue: minValue, maxValue: maxValue, defaultValue: defaultValue)
        self.snapEnabled = snapEnabled
        self.snapValue = snapValue
        self.snapThreshold = snapThreshold
    }

    /// Converts the normalized value (0…1) to the absolute range.
    /// For example:
    /// - minValue = 0
    /// - maxValue = 100
    /// - currentValue = 0.5 → **50**
    public var absoluteValue: Double {
        get {
            minValue + (currentValue * (maxValue - minValue))
        }
        set {
            currentValue = ((newValue - minValue) / (maxValue - minValue))
                .clamped(to: 0...1)
        }
    }

    /// Current angle of the knob, based on normalized value.
    public var angle: Double {
        minAngle + currentValue * (maxAngle - minAngle)
    }

    /// Angle corresponding to the default normalized value.
    public var defaultAngle: Double {
        minAngle + defaultValue * (maxAngle - minAngle)
    }

    /// Sets the current value, ensuring it remains in 0…1 range.
    public func setCurrentValue(_ val: Double) {
        currentValue = val.clamped(to: 0...1)
    }

    /// Handles drag movement for the radial knob.
    /// Dragging up increases value, dragging down decreases.
    /// - Parameter gesture: Drag gesture value from SwiftUI.
    public func handleDrag(gesture: DragGesture.Value) {
        if startValue == nil { startValue = currentValue }

        // Drag amount mapped to normalized delta
        let dragDelta = -gesture.translation.height / 150
        let newValue = (startValue ?? 0) + dragDelta

        setCurrentValue(newValue)
    }

    /// Ends the drag and applies snapping if enabled.
    public func handleDragEnd() {
        if snapEnabled,
           abs(currentValue - snapValue) < snapThreshold {
            currentValue = snapValue
        }
        startValue = nil
    }

    /// Resets the knob to its default normalized value.
    public func reset() {
        setCurrentValue(defaultValue)
    }
}
