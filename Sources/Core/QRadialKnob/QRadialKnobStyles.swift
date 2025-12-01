//
//  File.swift
//  QKnobs
//
//  Created by Володимир on 30.11.2025.
//

import Foundation
import SwiftUI

public protocol QRadialKnobStyle {
    associatedtype Body: View

    @ViewBuilder
    func makeBody(configuration: QRadialKnobStyleConfiguration) -> Body
}

public struct QRadialKnobStyleConfiguration {
    public let viewModel: QRadialKnobViewModel
    public let geometry: CGSize
}

public struct AnyQRadialKnobStyle: QRadialKnobStyle, @unchecked Sendable {
    private let _makeBody: @Sendable (QRadialKnobStyleConfiguration) -> AnyView

    public init<S: QRadialKnobStyle & Sendable>(_ style: S) {
        _makeBody = { AnyView(style.makeBody(configuration: $0)) }
    }

    public func makeBody(configuration: QRadialKnobStyleConfiguration) -> some View {
        _makeBody(configuration)
    }
}

private struct QRadialKnobStyleKey: EnvironmentKey {
    static let defaultValue = AnyQRadialKnobStyle(.basic)
}

public extension EnvironmentValues {
    var radialKnobStyle: AnyQRadialKnobStyle {
        get { self[QRadialKnobStyleKey.self] }
        set { self[QRadialKnobStyleKey.self] = newValue }
    }
}

public extension View {
    public func radialKnobStyle<S: QRadialKnobStyle & Sendable>(_ style: S) -> some View {
        environment(\.radialKnobStyle, AnyQRadialKnobStyle(style))
    }
}

public struct QRadialKnobStyles {}

public extension QRadialKnobStyles {
    public struct Basic: QRadialKnobStyle, Sendable {
        public init() {}
        public func makeBody(configuration: QRadialKnobStyleConfiguration) -> some View {
            let viewModel = configuration.viewModel
            ZStack {
                Circle()
                    .fill(.black.opacity(0.8))
                    .shadow(radius: 4)

                Rectangle()
                    .fill(viewModel.snapEnabled ? .gray : .gray.opacity(0.3))
                    .frame(width: configuration.geometry.width * 0.05, height: configuration.geometry.width * 0.2)
                    .offset(y: -configuration.geometry.height / 1.6)
                    .rotationEffect(.degrees(viewModel.defaultAngle))

                Circle()
                    .fill(.gray.opacity(0.8))
                    .frame(width: configuration.geometry.width * 0.75)

                Circle()
                    .fill(.white)
                    .frame(width: configuration.geometry.width * 0.1)
                    .offset(y: -configuration.geometry.height / 4)
                    .rotationEffect(.degrees(viewModel.angle))
            }
        }
    }

    struct Modern: QRadialKnobStyle, Sendable {
        public init() {}
        public func makeBody(configuration: QRadialKnobStyleConfiguration) -> some View {
            let viewModel = configuration.viewModel

            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.gray, .black],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .shadow(radius: 6)

                Circle()
                    .stroke(.white.opacity(0.3), lineWidth: 4)
                    .frame(width: configuration.geometry.width * 0.8)

                Circle()
                    .fill(.white.opacity(0.9))
                    .frame(width: configuration.geometry.width * 0.08)
                    .offset(y: -configuration.geometry.height / 4)
                    .rotationEffect(.degrees(viewModel.angle))
            }
        }
    }

    struct Wood: QRadialKnobStyle, Sendable {
        public init() {}
        public func makeBody(configuration: QRadialKnobStyleConfiguration) -> some View {
            let viewModel = configuration.viewModel

            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.brown, .black],
                            center: .center,
                            startRadius: 10,
                            endRadius: configuration.geometry.width * 0.5
                        )
                    )
                    .shadow(radius: 5)

                Circle()
                    .stroke(.black.opacity(0.4), lineWidth: 3)
                    .frame(width: configuration.geometry.width * 0.8)

                Circle()
                    .fill(.yellow.opacity(0.7))
                    .frame(width: configuration.geometry.width * 0.1)
                    .offset(y: -configuration.geometry.height / 4)
                    .rotationEffect(.degrees(viewModel.angle))
            }
        }
    }
}

public extension QRadialKnobStyle where Self == QRadialKnobStyles.Basic {
    static var basic: QRadialKnobStyles.Basic { .init() }
}

public extension QRadialKnobStyle where Self == QRadialKnobStyles.Modern {
    static var modern: QRadialKnobStyles.Modern { .init() }
}

public extension QRadialKnobStyle where Self == QRadialKnobStyles.Wood {
    static var wood: QRadialKnobStyles.Wood { .init() }
}
