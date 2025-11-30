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
import SwiftUI

public protocol QControlProtocol {
    var active: Bool { get set}
    var currentValue: Double { get }
}
