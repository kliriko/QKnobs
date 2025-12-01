//
//  File.swift
//  QKnobs
//
//  Created by Володимир on 27.11.2025.
//

import Foundation

/// Stores paramteres pulled from QControls in the structure of a basic amp.
struct QAmplifierSettings: Equatable {
    var gain: Double = 0
    var bass: Double = 0
    var mid: Double = 0
    var treble: Double = 0
    var presense: Double = 0
    var volume: Double = 0
}

/// Options for the style knob on the amp
public enum AmpSettingsExample: String, CaseIterable {
    case delay = "delay"
    case reverb = "reverb"
    case delayreverb = "delay+reverb"
    case chorus = "chorus"
    case blade = "blade"
    case fuzz = "fuzz"
    case clean = "clean"
}
