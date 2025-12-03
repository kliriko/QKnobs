# QKnobs

QKnobs is a lightweight SwiftUI library providing customizable continuous and discrete knobs, plus a simple fader control. Designed for audio apps, control panels, and any UI that needs rotary or slider-based input.

### Features

🎚 QRadialKnobView — continuous knob with min/max, snapping, and custom value overlays
🔘 QDiscreteKnobView — stepped knob backed by enums, with custom labels
🎛 QFaderView — vertical fader control
🔧 Fully SwiftUI-native
🪶 Lightweight and MIT-licensed

### Installation

Swift Package Manager
https://github.com/kliriko/QKnobs.git
Or add to Package.swift:
.package(url: "https://github.com/kliriko/QKnobs.git", .upToNextMajor(from: "1.0.0"))

Cocapods https://cocoapods.org/pods/QKnobs

### Usage

```swift
import QKnobs

struct ContentView: View {
@StateObject private var amp = QAmplifierViewModel()

var body: some View {
    HStack {
        // Discrete knob
        QDiscreteKnobView()
            .frame(width: 100, height: 100)

        // Continuous knob
        QRadialKnobView(viewModel: amp.gain)
            .frame(width: 100, height: 100)

        // Fader
        QFaderView(viewModel: amp.volume)
            .frame(width: 50, height: 200)
    }
}
```

### Customization

```swift
.knobValueView { ... } — customize the value display
.knobMinView / .knobMaxView — custom min/max labels
.knobAccessory { ... } — add center accessories
.knobLabel { ... } — custom labels for discrete options
```

### License
MIT License. Free for personal and commercial use.
