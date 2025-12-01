//
//  SwiftUIView.swift
//  QKnobs
//
//  Created by Володимир on 27.11.2025.
//

import SwiftUI

public struct QAmplifierView: View {
    @StateObject var viewModel = QAmplifierViewModel()
    
    public init() { }

    public var body: some View {
        HStack(spacing: 50) {
            VStack {
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
            }
            
            VStack {
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
            }
            
            VStack {
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
            }
            
            VStack {
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
            }
            
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
