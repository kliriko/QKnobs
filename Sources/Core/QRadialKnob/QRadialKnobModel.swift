//
//  File.swift
//  QKnobs
//
//  Created by Володимир on 30.11.2025.
//

import Foundation

/// Set of requirements for the continious control
public protocol QContiniousControlProtocol: QControlProtocol {
    var defaultValue: Double { get }
    var minValue: Double { get }
    var maxValue: Double { get }
    
    var snapEnabled: Bool { get set }
    var snapValue: Double { get }
    var snapThreshold: Double { get }
    
    var absoluteValue: Double { get set }
}

/// Set of requirements for the radial knob
public protocol QRadialKnobProtocol: QContiniousControlProtocol {
    var minAngle: Double { get }
    var maxAngle: Double { get }
    var angle: Double { get }
    var defaultAngle: Double { get }
}
