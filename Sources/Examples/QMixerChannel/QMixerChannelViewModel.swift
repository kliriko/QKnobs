//
//  File.swift
//  QKnobs
//
//  Created by Володимир on 30.11.2025.
//

import Foundation
import SwiftUI
import Combine

public class QMixerChannelViewModel: ObservableObject {
    @Published var ampSettings: QMixerChannelSettings = QMixerChannelSettings()

    let gain = QRadialKnobViewModel()
    let bass = QRadialKnobViewModel()
    let mid = QRadialKnobViewModel()
    let treble = QRadialKnobViewModel()
    let volume = QFaderViewModel()

    private var cancellables = Set<AnyCancellable>()

    public init() {
        linkControlsToSettings()
        applySettingsToControls()
    }
}

public extension QMixerChannelViewModel {
    func applySettingsToControls() {
        gain.absoluteValue = ampSettings.gain
        bass.absoluteValue = ampSettings.bass
        mid.absoluteValue = ampSettings.mid
        treble.absoluteValue = ampSettings.treble
        volume.absoluteValue = ampSettings.volume
    }
}

private extension QMixerChannelViewModel {
    func linkControlsToSettings() {
        gain.$currentValue
            .sink { [weak self] _ in
                self?.ampSettings.gain = self?.gain.absoluteValue ?? 0
            }
            .store(in: &cancellables)

        bass.$currentValue
            .sink { [weak self] _ in
                self?.ampSettings.bass = self?.bass.absoluteValue ?? 0
            }
            .store(in: &cancellables)

        mid.$currentValue
            .sink { [weak self] _ in
                self?.ampSettings.mid = self?.mid.absoluteValue ?? 0
            }
            .store(in: &cancellables)

        treble.$currentValue
            .sink { [weak self] _ in
                self?.ampSettings.treble = self?.treble.absoluteValue ?? 0
            }
            .store(in: &cancellables)

        volume.$currentValue
            .sink { [weak self] _ in
                self?.ampSettings.volume = self?.volume.absoluteValue ?? 0
            }
            .store(in: &cancellables)
    }
}
