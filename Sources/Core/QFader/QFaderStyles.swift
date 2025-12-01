//
//  QFaderStyles.swift
//  QKnobs
//
//  Created by Володимир on 30.11.2025.
//

import Foundation
import SwiftUI

/// Protocol that requires view to have a body to count as a style
public protocol QFaderStyle {
    associatedtype Body: View
    @ViewBuilder func makeBody(configuration: QFaderStyleConfiguration) -> Body
}

/// Abstraction to link discrete Fader view and custom style
public struct QFaderStyleConfiguration {
    public let viewModel: QFaderViewModel
    public let geometry: CGSize
}

/// Used to enable different style usage
public struct AnyQFaderStyle: QFaderStyle, @unchecked Sendable {
    private let _makeBody: @Sendable (QFaderStyleConfiguration) -> AnyView

    public init<S: QFaderStyle & Sendable>(_ style: S) {
        _makeBody = { AnyView(style.makeBody(configuration: $0)) }
    }

    public func makeBody(configuration: QFaderStyleConfiguration) -> some View {
        _makeBody(configuration)
    }
}

/// Enables style usage as an environment variable
private struct QFaderStyleKey: EnvironmentKey {
    static let defaultValue = AnyQFaderStyle(QFaderStyles.Basic())
}

public extension EnvironmentValues {
    var faderStyle: AnyQFaderStyle {
        get { self[QFaderStyleKey.self] }
        set { self[QFaderStyleKey.self] = newValue }
    }
}

public extension View {
    func faderStyle<S: QFaderStyle & Sendable>(_ style: S) -> some View {
        environment(\.faderStyle, AnyQFaderStyle(style))
    }
}

public struct QFaderStyles {
    /// Default style of the control
    public struct Basic: QFaderStyle, Sendable {
        public init() {}

        public func makeBody(configuration: QFaderStyleConfiguration) -> some View {
            let viewModel = configuration.viewModel
            let snapY = (1 - viewModel.snapValue) * (2 * viewModel.trackHeight) - viewModel.trackHeight

            ZStack {
                // Track
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 3)
                    .frame(maxHeight: .infinity)

                // Snap indicator
                Rectangle()
                    .fill(viewModel.snapEnabled ? Color.gray : Color.gray.opacity(0.3))
                    .frame(height: 2)
                    .offset(y: snapY)
                    .allowsHitTesting(false)

                // Handle
                Rectangle()
                    .fill(Color.blue)
                    .overlay(
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: max(viewModel.handleWidth - 8, 0), height: 2)
                            .position(x: viewModel.handleWidth / 2, y: viewModel.handleHeight / 2)
                    )
                    .frame(width: viewModel.handleWidth, height: viewModel.handleHeight)
                    .offset(y: viewModel.offsetY)
                    .animation(.easeInOut(duration: 0.2), value: viewModel.offsetY)
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }

    /// Modern style of the control
    public struct Modern: QFaderStyle, Sendable {
        public init() {}

        public func makeBody(configuration: QFaderStyleConfiguration) -> some View {
            let viewModel = configuration.viewModel
            let snapY = (1 - viewModel.snapValue) * (2 * viewModel.trackHeight) - viewModel.trackHeight

            ZStack {
                // Track
                RoundedRectangle(cornerRadius: 3)
                    .fill(
                        LinearGradient(colors: [.black, .gray], startPoint: .top, endPoint: .bottom)
                    )
                    .frame(width: 6)
                    .frame(maxHeight: .infinity)
                    .shadow(radius: 3)

                // Snap indicator
                Rectangle()
                    .fill(viewModel.snapEnabled ? Color.white.opacity(0.6) : Color.white.opacity(0.3))
                    .frame(height: 3)
                    .frame(maxWidth: 20)
                    .offset(y: snapY)
                    .allowsHitTesting(false)

                // Handle
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.accentColor)
                    .overlay(
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: max(viewModel.handleWidth - 8, 0), height: 2)
                            .position(x: viewModel.handleWidth / 2, y: viewModel.handleHeight / 2)
                    )
                    .frame(width: viewModel.handleWidth, height: viewModel.handleHeight)
                    .offset(y: viewModel.offsetY)
                    .shadow(radius: 2)
                    .animation(.easeInOut(duration: 0.2), value: viewModel.offsetY)
                    
            }
        }
    }

    /// 'Wooden' style of the control
    public struct Wood: QFaderStyle, Sendable {
        public init() {}

        public func makeBody(configuration: QFaderStyleConfiguration) -> some View {
            let viewModel = configuration.viewModel
            let snapY = (1 - viewModel.snapValue) * (2 * viewModel.trackHeight) - viewModel.trackHeight

            ZStack {
                // Track
                Rectangle()
                    .fill(
                        LinearGradient(colors: [.brown, .black], startPoint: .top, endPoint: .bottom)
                    )
                    .frame(width: 5)
                    .frame(maxHeight: .infinity)
                    .cornerRadius(2)
                    .shadow(radius: 3)

                // Snap indicator
                Rectangle()
                    .fill(viewModel.snapEnabled ? Color.yellow.opacity(0.6) : Color.yellow.opacity(0.3))
                    .frame(height: 2)
                    .frame(maxWidth: 20)
                    .offset(y: snapY)
                    .allowsHitTesting(false)

                // Handle
                Rectangle()
                    .fill(Color.yellow)
                    .overlay(
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: max(viewModel.handleWidth - 8, 0), height: 2)
                            .position(x: viewModel.handleWidth / 2, y: viewModel.handleHeight / 2)
                    )
                    .frame(width: viewModel.handleWidth, height: viewModel.handleHeight)
                    .cornerRadius(4)
                    .offset(y: viewModel.offsetY)
                    .shadow(radius: 2)
                    .animation(.easeInOut(duration: 0.2), value: viewModel.offsetY)
                    .overlay(
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: max(viewModel.handleWidth - 8, 0), height: 2)
                            .position(x: viewModel.handleWidth / 2, y: viewModel.handleHeight / 2)
                    )
            }
        }
    }
}

public extension QFaderStyle where Self == QFaderStyles.Basic {
    static var basic: QFaderStyles.Basic { .init() }
}

public extension QFaderStyle where Self == QFaderStyles.Modern {
    static var modern: QFaderStyles.Modern { .init() }
}

public extension QFaderStyle where Self == QFaderStyles.Wood {
    static var wood: QFaderStyles.Wood { .init() }
}
