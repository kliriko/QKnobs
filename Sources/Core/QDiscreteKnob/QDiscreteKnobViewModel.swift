//
//  File.swift
//  QKnobs
//
//  Created by Володимир on 28.11.2025.
//

import Foundation
import SwiftUI

/// Implements logic of ``QDiscreteKnobView``
public final class QDiscreteKnobViewModel: ObservableObject, Observable, QDiscreteKnobProtocol {
    public typealias EnumType = AmpSettingsExample
    @Published public var currentSelection: EnumType = EnumType.allCases.first!
    
    public var allOptions: [EnumType] { EnumType.allCases }
    
    /// Y-axis offset in the beginning of the drag. Used to calculate the difference in position
    private var startDragY: CGFloat?
    /// Index of the element in the beginning of the drag. Used to calculate the difference in position
    private var startIndex: Int?
    /// Difference in drag to switch to another option
    private let stepThreshold: CGFloat = 10.0
    
    public init() { }
    
    /// Calculates an angle needed to create even space on the options circle
    public func angle(for option: EnumType) -> Double {
        guard let index = index(of: option) else { return 0 }
        let stepAngle = 360.0 / Double(allOptions.count)
        return -Double(index) * stepAngle
    }
    
    /// Selection logic
    public func handleDrag(gesture: DragGesture.Value) {
        print("HANDLE DRAG CALLED: \(gesture.location)")
        if startDragY == nil {
            startDragY = gesture.startLocation.y
            startIndex = index(of: currentSelection)
            return
        }

        guard let startY = startDragY,
              let startIdx = startIndex,
              !allOptions.isEmpty else {
            return
        }

        let deltaY = gesture.location.y - startY
        let stepsMoved = Int((deltaY / stepThreshold ).rounded())

        let count = allOptions.count
        let newIndex = (startIdx - stepsMoved).positiveModulo(count)
       
        currentSelection = allOptions[newIndex]
    }
    
    /// Resets data from previous calculation.
    public func handleDragEnd() {
        startDragY = nil
        startIndex = nil
    }
    
    /// Helper method to get an index in the actual options array.
    private func index(of option: EnumType) -> Int? {
        return allOptions.firstIndex(of: option)
    }
}
