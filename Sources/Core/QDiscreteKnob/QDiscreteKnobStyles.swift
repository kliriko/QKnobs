//
//  File.swift
//  QKnobs
//
//  Created by Володимир on 30.11.2025.
//

import SwiftUI
import Foundation

/// Protocol that required a view to have a body to count as a style
public protocol QDiscreteKnobStyle {
    associatedtype Body: View
    @ViewBuilder func makeBody(configuration: QDiscreteKnobStyleConfiguration) -> Body
}

/// Abstraction to link discrete knob view and custom style
public struct QDiscreteKnobStyleConfiguration {
    public let viewModel: QDiscreteKnobViewModel
    public let geometry: CGSize
}

/// Used to enable different style usage
public struct AnyQDiscreteKnobStyle: QDiscreteKnobStyle, @unchecked Sendable {
    private let _makeBody: @Sendable (QDiscreteKnobStyleConfiguration) -> AnyView

    public init<S: QDiscreteKnobStyle & Sendable>(_ style: S) {
        _makeBody = { AnyView(style.makeBody(configuration: $0)) }
    }

    public func makeBody(configuration: QDiscreteKnobStyleConfiguration) -> some View {
        _makeBody(configuration)
    }
}

/// Enables style usage as an environment variable
private struct QDiscreteKnobStyleKey: EnvironmentKey {
    static let defaultValue = AnyQDiscreteKnobStyle(QDiscreteKnobStyles.Basic())
}

public extension EnvironmentValues {
    var discreteKnobStyle: AnyQDiscreteKnobStyle {
        get { self[QDiscreteKnobStyleKey.self] }
        set { self[QDiscreteKnobStyleKey.self] = newValue }
    }
}


public extension View {
    func discreteKnobStyle<S: QDiscreteKnobStyle & Sendable>(_ style: S) -> some View {
        environment(\.discreteKnobStyle, AnyQDiscreteKnobStyle(style))
    }
}

/// Stores all styles available for the knob
public struct QDiscreteKnobStyles {}

public extension QDiscreteKnobStyles {
    /// Default style of the control
    struct Basic: QDiscreteKnobStyle, Sendable {
        public init() {}

        public func makeBody(configuration: QDiscreteKnobStyleConfiguration) -> some View {
            let viewModel = configuration.viewModel

            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.2))

                ForEach(Array(viewModel.allOptions.enumerated()), id: \.offset) { _, option in
                    Rectangle()
                        .fill(Color.gray.opacity(0.6))
                        .frame(width: 3, height: 10)
                        .offset(y: -configuration.geometry.height / 2.2)
                        .rotationEffect(.degrees(viewModel.angle(for: option)))
                }

                Rectangle()
                    .fill(Color.accentColor)
                    .frame(width: 4, height: 30)
                    .offset(y: -configuration.geometry.height / 3.2)
                    .rotationEffect(.degrees(viewModel.angle(for: viewModel.currentSelection) + Double((360 / viewModel.allOptions.count))))

                Circle()
                    .fill(Color.accentColor)
                    .frame(width: 20)
            }
        }
    }

    /// Modern style of the control
    /// Modern style — sleek black metal look
    struct Modern: QDiscreteKnobStyle, Sendable {
        public init() {}

        public func makeBody(configuration: QDiscreteKnobStyleConfiguration) -> some View {
            let viewModel = configuration.viewModel
            let size = configuration.geometry

            ZStack {
                // Main body
                Circle()
                    .fill(LinearGradient(colors: [.black, .gray.opacity(0.8)], startPoint: .top, endPoint: .bottom))
                    .shadow(color: .black.opacity(0.6), radius: 10, x: 0, y: 5)

                // Outer rim highlight
                Circle()
                    .strokeBorder(LinearGradient(colors: [.white.opacity(0.4), .clear], startPoint: .top, endPoint: .bottom), lineWidth: 4)
                    .frame(width: size.width * 0.92)

                // Tick marks
                ForEach(viewModel.allOptions, id: \.self) { option in
                    Capsule()
                        .fill(Color.white.opacity(0.5))
                        .frame(width: 3, height: 14)
                        .offset(y: -size.height / 2.25)
                        .rotationEffect(.degrees(viewModel.angle(for: option)))
                }

                // Main indicator (pointer) — THIS WAS THE FIX
                Capsule()
                    .fill(Color.white)
                    .frame(width: 5, height: 42)
                    .offset(y: -size.height / 3.0)
                    //.rotationEffect(.degrees(viewModel.angle(for: viewModel.currentSelection)))
                    .rotationEffect(.degrees(viewModel.angle(for: viewModel.currentSelection) + Double((360 / viewModel.allOptions.count))))
                    .shadow(radius: 3)

                // Center cap
                Circle()
                    .fill(RadialGradient(colors: [.white, .white.opacity(0.6)], center: .center, startRadius: 2, endRadius: 12))
                    .frame(width: 26)
                    .overlay(
                        Circle()
                            .stroke(Color.black.opacity(0.3), lineWidth: 2)
                            .frame(width: 26)
                    )
                    .shadow(radius: 4)
            }
        }
    }

    /// Wood style — vintage amp knob feel
    struct Wood: QDiscreteKnobStyle, Sendable {
        public init() {}

        public func makeBody(configuration: QDiscreteKnobStyleConfiguration) -> some View {
            let viewModel = configuration.viewModel
            let size = configuration.geometry

            ZStack {
                // Wooden body
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color(white: 0.45), Color(white: 0.25), .black],
                            center: .center,
                            startRadius: 5,
                            endRadius: size.width / 2
                        )
                    )
                    .overlay(
                        Circle()
                            .stroke(Color(white: 0.3), lineWidth: 3)
                            .frame(width: size.width * 0.88)
                    )
                    .shadow(color: .black.opacity(0.7), radius: 8, x: 0, y: 4)

                // Wood grain ticks
                ForEach(viewModel.allOptions, id: \.self) { option in
                    Rectangle()
                        .fill(Color.orange.opacity(0.7))
                        .frame(width: 4, height: 16)
                        .offset(y: -size.height / 2.2)
                        .rotationEffect(.degrees(viewModel.angle(for: option)))
                }

                // Golden pointer — THIS WAS THE FIX
                Rectangle()
                    .fill(LinearGradient(colors: [.yellow, .orange], startPoint: .top, endPoint: .bottom))
                    .frame(width: 6, height: 48)
                    .cornerRadius(3)
                    .offset(y: -size.height / 3.1)
                    .rotationEffect(.degrees(viewModel.angle(for: viewModel.currentSelection))) // ← REMOVED the extra "-"
                    .shadow(radius: 2)

                // Center rivet
                Circle()
                    .fill(RadialGradient(colors: [.yellow.opacity(0.9), .orange], center: .center, startRadius: 3, endRadius: 14))
                    .frame(width: 28)
                    .overlay(Circle().stroke(Color.black.opacity(0.4), lineWidth: 2))
                    .shadow(color: .black.opacity(0.5), radius: 3)
            }
        }
    }
}

public extension QDiscreteKnobStyle where Self == QDiscreteKnobStyles.Basic {
    static var basic: QDiscreteKnobStyles.Basic { .init() }
}

public extension QDiscreteKnobStyle where Self == QDiscreteKnobStyles.Modern {
    static var modern: QDiscreteKnobStyles.Modern { .init() }
}

public extension QDiscreteKnobStyle where Self == QDiscreteKnobStyles.Wood {
    static var wood: QDiscreteKnobStyles.Wood { .init() }
}
