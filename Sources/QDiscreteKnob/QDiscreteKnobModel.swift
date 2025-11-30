//
//  File.swift
//  QKnobs
//
//  Created by Володимир on 30.11.2025.
//

import Foundation

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
