//
//  File.swift
//  QKnobs
//
//  Created by Володимир on 28.11.2025.
//

import Foundation
import SwiftUI

public enum AmpSettingsExample: String, CaseIterable {
    case delay = "delay"
    case reverb = "reverb"
    case delayreverb = "delay+reverb"
    case chorus = "chorus"
    case blade = "blade"
    case fuzz = "fuzz"
    case clean = "clean"
}

public final class QDiscreteKnobViewModel: ObservableObject, Observable, QDiscreteKnobProtocol {
    public typealias EnumType = AmpSettingsExample
    @Published public var active: Bool = true
    @Published public var currentSelection: EnumType = .clean
    
    private var startDragY: CGFloat?
    private var startIndex: Int?
    private let stepThreshold: CGFloat = 10.0
    
    public var allOptions: [EnumType] { EnumType.allCases }
    
    public init() { }
    
    private func index(of option: EnumType) -> Int? {
        return allOptions.firstIndex(of: option)
    }
    
    public func angle(for option: EnumType) -> Double {
        guard let index = index(of: option) else { return 0 }
        let steps = Double(index)
        let total = Double(allOptions.count)
        return -steps * (360.0 / total)
    }
    
    public func handleDrag(gesture: DragGesture.Value) {
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
        let stepsMoved = Int((deltaY / stepThreshold).rounded())
        
        let count = allOptions.count
        let newIndex = (startIdx + stepsMoved).positiveModulo(count)
        
        currentSelection = allOptions[newIndex]
    }
    
    public func handleDragEnd() {
        startDragY = nil
        startIndex = nil
    }
}

private extension Int {
    func positiveModulo(_ modulus: Int) -> Int {
        let mod = self % modulus
        return mod >= 0 ? mod : mod + modulus
    }
}
