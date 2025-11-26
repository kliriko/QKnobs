//
//  File.swift
//  QKnobs
//
//  Created by Володимир on 25.11.2025.
//

import Foundation

/* План
 1. радіальна крутилка яка перемикається по засічкам. тобто чітко 1 2 3 і так далі
 2. можливість замінити вигляд крутилки та фейдеру
 3. клас який обʼєднує кнопки і крутилки в одне.
 */

/// All values are relative from 0 to 1.
public protocol QControl {
    var active: Bool { get set}
    var currentValue: Double { get }
    var defaultValue: Double { get }
    
    var minValue: Double { get }
    var maxValue: Double { get }
    
    var snapEnabled: Bool { get set }
    var snapValue: Double { get }
    var snapThreshold: Double { get }
    var feedbackEnabled: Bool { get }
    
    var absoluteValue: Double { get set }
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
