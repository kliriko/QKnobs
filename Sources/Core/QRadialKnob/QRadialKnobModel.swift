//
//  File.swift
//  QKnobs
//
//  Created by Володимир on 30.11.2025.
//

import Foundation

public protocol QContiniousControlProtocol: QControlProtocol {
    var defaultValue: Double { get }
    var minValue: Double { get }
    var maxValue: Double { get }
    
    var snapEnabled: Bool { get set }
    var snapValue: Double { get }
    var snapThreshold: Double { get }
    
    var absoluteValue: Double { get set }
}

public protocol QRadialKnobProtocol: QContiniousControlProtocol {
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
