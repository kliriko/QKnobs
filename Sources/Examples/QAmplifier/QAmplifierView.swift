//
//  SwiftUIView.swift
//  QKnobs
//
//  Created by Володимир on 27.11.2025.
//

import SwiftUI

/// Shows off framework's main controls such as radial knob, discrete knob and a fader
public struct QAmplifierView: View {
    @StateObject var viewModel = QAmplifierViewModel()
    
    public init() { }

    public var body: some View {
        HStack(spacing: 50) {
            QDiscreteKnobView()
                .knobLabel { bindable, option in
                    Text(option.rawValue.uppercased())
                        .font(.system(size: 9, weight: .bold, design: .rounded))
                        .foregroundStyle(bindable.wrappedValue.currentSelection == option ? .yellow : .white.opacity(0.7))
                        .padding(.horizontal, 7)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color.black.opacity(0.6))
                                .opacity(bindable.wrappedValue.currentSelection == option ? 1 : 0)
                        )
                        .offset(y: -38)
                        .rotationEffect(.degrees(bindable.wrappedValue.angle(for: option)))
                        .rotationEffect(.degrees(90))
                        .scaleEffect(bindable.wrappedValue.currentSelection == option ? 1.15 : 1.0)
                        .animation(.easeOut(duration: 0.2), value: bindable.wrappedValue.currentSelection)
                }
                .discreteKnobStyle(.basic)
                .frame(width: 120, height: 120)
            
            QRadialKnobView(viewModel: viewModel.gain)
                .knobValueView { viewModel in
                    HStack {
                        Text("gain: \(viewModel.absoluteValue.wrappedValue, specifier: "%.1f")")
                        Button(action: {
                            viewModel.snapEnabled.wrappedValue.toggle()
                        }, label: {
                            Image(systemName: "link")
                        })
                        .tint(viewModel.wrappedValue.snapEnabled ? .green : .gray)
                    }
                    .offset(x: 0, y: 85)
                }
                .knobMaxView { viewModel in
                    Text("\(viewModel.maxValue.wrappedValue, specifier: "%.1f")")
                        .offset(x: 65, y: 40)
                }
                .knobMinView { viewModel in
                    Text("\(viewModel.minValue.wrappedValue, specifier: "%.1f")")
                        .offset(x: -65, y: 40)
                }
                .frame(width: 120, height: 120)
            
            QRadialKnobView(viewModel: viewModel.bass)
                .knobValueView { viewModel in
                    HStack {
                        Text("bass: \(viewModel.absoluteValue.wrappedValue, specifier: "%.1f")")
                        Button(action: {
                            viewModel.snapEnabled.wrappedValue.toggle()
                        }, label: {
                            Image(systemName: "link")
                        })
                        .tint(viewModel.wrappedValue.snapEnabled ? .green : .gray)
                    }
                    .offset(x: 0, y: 85)
                }
                .knobMaxView { viewModel in
                    Text("\(viewModel.maxValue.wrappedValue, specifier: "%.1f")")
                        .offset(x: 65, y: 40)
                }
                .knobMinView { viewModel in
                    Text("\(viewModel.minValue.wrappedValue, specifier: "%.1f")")
                        .offset(x: -65, y: 40)
                }
                .frame(width: 120, height: 120)
            
            
            
            QRadialKnobView(viewModel: viewModel.mid)
                .knobValueView { viewModel in
                    HStack {
                        Text("mid: \(viewModel.absoluteValue.wrappedValue, specifier: "%.1f")")
                        Button(action: {
                            viewModel.snapEnabled.wrappedValue.toggle()
                        }, label: {
                            Image(systemName: "link")
                        })
                        .tint(viewModel.wrappedValue.snapEnabled ? .green : .gray)
                    }
                    .offset(x: 0, y: 85)
                }
                .knobMaxView { viewModel in
                    Text("\(viewModel.maxValue.wrappedValue, specifier: "%.1f")")
                        .offset(x: 65, y: 40)
                }
                .knobMinView { viewModel in
                    Text("\(viewModel.minValue.wrappedValue, specifier: "%.1f")")
                        .offset(x: -65, y: 40)
                }
                .frame(width: 120, height: 120)
            
            
            QRadialKnobView(viewModel: viewModel.treble)
                .knobValueView { viewModel in
                    HStack {
                        Text("treble: \(viewModel.absoluteValue.wrappedValue, specifier: "%.1f")")
                        Button(action: {
                            viewModel.snapEnabled.wrappedValue.toggle()
                        }, label: {
                            Image(systemName: "link")
                        })
                        .tint(viewModel.wrappedValue.snapEnabled ? .green : .gray)
                    }
                    .offset(x: 0, y: 85)
                }
                .knobMaxView { viewModel in
                    Text("\(viewModel.maxValue.wrappedValue, specifier: "%.1f")")
                        .offset(x: 65, y: 40)
                }
                .knobMinView { viewModel in
                    Text("\(viewModel.minValue.wrappedValue, specifier: "%.1f")")
                        .offset(x: -65, y: 40)
                }
                .frame(width: 120, height: 120)
            
            
            VStack {
                QFaderView(viewModel: viewModel.volume)
                    .minView { viewModel in
                        Text("\(viewModel.minValue, specifier: "%.1f") dB")
                            .foregroundStyle(Color.green)
                            .offset(x: -40, y: 100)
                    }
                    .maxView { viewModel in
                        Text("+\(viewModel.maxValue, specifier: "%.1f") dB")
                            .foregroundStyle(Color.red)
                            .offset(x: -40, y: -100)
                    }
                    .faderSnapButton { viewModel in
                        VStack {
                            Text("\(viewModel.absoluteValue, specifier: "%.1f")")
                            
                            Button(action: {
                                viewModel.snapEnabled.toggle()
                            }, label: {
                                Image(systemName: "link")
                            })
                            .tint(viewModel.snapEnabled ? .green : .gray)
                        }
                        .offset(x: 60)
                    }
                    .frame(width: 60, height: 300)
                Text("volume")
            }
        }
        .padding(.horizontal, 20)
        .onChange(of: viewModel.ampSettings) {
            print(viewModel.ampSettings)
        }
    }
}

#Preview {
    QAmplifierView()
}
