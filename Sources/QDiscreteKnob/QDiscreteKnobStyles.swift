//
//  File.swift
//  QKnobs
//
//  Created by Володимир on 30.11.2025.
//

import SwiftUI
import Foundation

// MARK: - Protocol

public protocol QDiscreteKnobStyle {
    associatedtype Body: View
    @ViewBuilder
    func makeBody(configuration: QDiscreteKnobStyleConfiguration) -> Body
}

public struct QDiscreteKnobStyleConfiguration {
    public let viewModel: QDiscreteKnobViewModel
    public let geometry: CGSize
}

// MARK: - Type Eraser

public struct AnyQDiscreteKnobStyle: QDiscreteKnobStyle, @unchecked Sendable {
    private let _makeBody: @Sendable (QDiscreteKnobStyleConfiguration) -> AnyView

    public init<S: QDiscreteKnobStyle & Sendable>(_ style: S) {
        _makeBody = { AnyView(style.makeBody(configuration: $0)) }
    }

    public func makeBody(configuration: QDiscreteKnobStyleConfiguration) -> some View {
        _makeBody(configuration)
    }
}

// MARK: - Environment Key

private struct QDiscreteKnobStyleKey: EnvironmentKey {
    static let defaultValue = AnyQDiscreteKnobStyle(QDiscreteKnobStyles.Basic())
}

public extension EnvironmentValues {
    var discreteKnobStyle: AnyQDiscreteKnobStyle {
        get { self[QDiscreteKnobStyleKey.self] }
        set { self[QDiscreteKnobStyleKey.self] = newValue }
    }
}

// MARK: - View Modifier

public extension View {
    func discreteKnobStyle<S: QDiscreteKnobStyle & Sendable>(_ style: S) -> some View {
        environment(\.discreteKnobStyle, AnyQDiscreteKnobStyle(style))
    }
}

// MARK: - Style Namespace

public struct QDiscreteKnobStyles {}

public extension QDiscreteKnobStyles {

    // MARK: - BASIC

    struct Basic: QDiscreteKnobStyle, Sendable {
        public init() {}

        public func makeBody(configuration: QDiscreteKnobStyleConfiguration) -> some View {
            let vm = configuration.viewModel

            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.2))

                ForEach(Array(vm.allOptions.enumerated()), id: \.offset) { _, option in
                    Rectangle()
                        .fill(Color.gray.opacity(0.6))
                        .frame(width: 3, height: 10)
                        .offset(y: -configuration.geometry.height / 2.2)
                        .rotationEffect(.degrees(vm.angle(for: option)))
                }

                Rectangle()
                    .fill(Color.accentColor)
                    .frame(width: 4, height: 30)
                    .offset(y: -configuration.geometry.height / 3.2)
                    .rotationEffect(.degrees(-vm.angle(for: vm.currentSelection)))

                Circle()
                    .fill(Color.accentColor)
                    .frame(width: 20)
            }
        }
    }

    // MARK: - MODERN

    struct Modern: QDiscreteKnobStyle, Sendable {
        public init() {}

        public func makeBody(configuration: QDiscreteKnobStyleConfiguration) -> some View {
            let vm = configuration.viewModel

            ZStack {
                Circle()
                    .fill(
                        LinearGradient(colors: [.black, .gray], startPoint: .top, endPoint: .bottom)
                    )
                    .shadow(radius: 6)

                Circle()
                    .stroke(.white.opacity(0.3), lineWidth: 4)
                    .frame(width: configuration.geometry.width * 0.85)

                ForEach(Array(vm.allOptions.enumerated()), id: \.offset) { _, option in
                    Capsule()
                        .fill(.white.opacity(0.4))
                        .frame(width: 2, height: 12)
                        .offset(y: -configuration.geometry.height / 2.3)
                        .rotationEffect(.degrees(vm.angle(for: option)))
                }

                Capsule()
                    .fill(.white)
                    .frame(width: 4, height: 36)
                    .offset(y: -configuration.geometry.height / 3.1)
                    .rotationEffect(.degrees(-vm.angle(for: vm.currentSelection)))

                Circle()
                    .fill(.white.opacity(0.8))
                    .frame(width: 22)
            }
        }
    }

    // MARK: - WOOD

    struct Wood: QDiscreteKnobStyle, Sendable {
        public init() {}

        public func makeBody(configuration: QDiscreteKnobStyleConfiguration) -> some View {
            let vm = configuration.viewModel

            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.brown, .black],
                            center: .center,
                            startRadius: 6,
                            endRadius: configuration.geometry.width * 0.5
                        )
                    )
                    .shadow(radius: 6)

                Circle()
                    .stroke(.black.opacity(0.4), lineWidth: 3)
                    .frame(width: configuration.geometry.width * 0.85)

                ForEach(Array(vm.allOptions.enumerated()), id: \.offset) { _, option in
                    Rectangle()
                        .fill(.yellow.opacity(0.6))
                        .frame(width: 3, height: 12)
                        .offset(y: -configuration.geometry.height / 2.2)
                        .rotationEffect(.degrees(vm.angle(for: option)))
                }

                Rectangle()
                    .fill(.yellow.opacity(0.9))
                    .frame(width: 4, height: 40)
                    .offset(y: -configuration.geometry.height / 3.2)
                    .rotationEffect(.degrees(-vm.angle(for: vm.currentSelection)))

                Circle()
                    .fill(.yellow.opacity(0.8))
                    .frame(width: 24)
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
