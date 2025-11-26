//
//  File.swift
//  QKnobs
//
//  Created by Володимир on 25.11.2025.
//

import Foundation

/// All values are relative from 0 to 1.
public protocol QControl {
    var active: Bool { get set}
    var currentValue: Double { get }
    var defaultValue: Double { get }
    
    var minValue: Double { get }
    var maxValue: Double { get }
    
    var snapEnabled: Bool { get }
    var snapValue: Double { get }
    var snapThreshold: Double { get }
    var feedbackEnabled: Bool { get }
    
    func getAbsoluteValue() -> Double
}

public protocol QRadialKnobProtocol: QControl {
    var minAngle: Double { get }
    var maxAngle: Double { get }
    var angle: Double { get }
    var defaultAngle: Double { get }
}

extension QRadialKnobProtocol {
    public var angle: Double {
        minAngle + (maxAngle - minAngle) * ((currentValue - minValue) / (maxValue - minValue))
    }
    
    public var defaultAngle: Double {
        minAngle + (maxAngle - minAngle) * ((defaultValue - minValue) / (maxValue - minValue))
    }
}

public protocol QFaderProtocol: QControl {
    
}
