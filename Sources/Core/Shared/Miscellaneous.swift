//
//  File.swift
//  QKnobs
//
//  Created by Володимир on 01.12.2025.
//

import Foundation

extension Int {
    func positiveModulo(_ modulus: Int) -> Int {
        let mod = self % modulus
        return mod >= 0 ? mod : mod + modulus
    }
}

extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
