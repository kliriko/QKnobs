//
//  File.swift
//  QKnobs
//
//  Created by Володимир on 25.11.2025.
//

// хочаб кілька скінів і можливість додавати свої
// канал фейдера
// подумати які параметри треба винести нагору

import Foundation

public struct QControl: Identifiable {
    public var id: String
    var connectedControl: any QControlProtocol
}

/// All values are relative from 0 to 1.
public protocol QControlProtocol {
    var active: Bool { get set}
    var currentValue: Double { get }
}

public protocol QContiniousControlProtocol: QControlProtocol {
    var defaultValue: Double { get }
    var minValue: Double { get }
    var maxValue: Double { get }
    
    var snapEnabled: Bool { get set }
    var snapValue: Double { get }
    var snapThreshold: Double { get }
    var feedbackEnabled: Bool { get }
    
    var absoluteValue: Double { get set }
}

// MARK: -
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

// MARK: -
public protocol QDiscreteKnobProtocol: QControlProtocol {
    associatedtype EnumType: CaseIterable, Equatable
    
    var currentSelection: EnumType { get set }
}

extension QDiscreteKnobProtocol {
    public var currentValue: Double {
        let all = Array(EnumType.allCases)
        let idx = all.firstIndex(of: currentSelection)!
        return Double(idx)
    }
    
    var allOptions: [EnumType] { Array(EnumType.allCases) }
}
