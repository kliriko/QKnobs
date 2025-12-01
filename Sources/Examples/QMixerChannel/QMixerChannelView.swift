//
//  QMixerChannelView.swift
//  QKnobs
//
//  Created by Володимир on 30.11.2025.
//

import SwiftUI

public struct QMixerChannelView: View {
    @StateObject var viewModel = QMixerChannelViewModel()
    
    public init() { }

    public var body: some View {
        VStack(spacing: 25) {
            VStack {
                Text("gain")
                    .font(.headline)
                    .padding(.bottom, 5)
                QRadialKnobView(viewModel: viewModel.gain)
                    .knobValueView { viewModel in
                        Text(String(format: "%.2f", viewModel.absoluteValue.wrappedValue))
                    }
                    .frame(width: 50, height: 50)
            }
            
            VStack {
                Text("bass")
                    .font(.headline)
                    .padding(.bottom, 5)
                QRadialKnobView(viewModel: viewModel.bass)
                    .frame(width: 50, height: 50)
            }
            
            VStack {
                Text("mid")
                    .font(.headline)
                    .padding(.bottom, 5)
                QRadialKnobView(viewModel: viewModel.mid)
                    .frame(width: 50, height: 50)
            }
            
            VStack {
                Text("treble")
                    .font(.headline)
                    .padding(.bottom, 5)
                QRadialKnobView(viewModel: viewModel.treble)
                    .frame(width: 50, height: 50)
            }
            
            VStack {
                Text("volume")
                    .font(.headline)
                    .padding(.bottom, 5)
                QFaderView()
                    .frame(width: 60, height: 200)
                    .padding(.vertical, viewModel.volume.handleHeight / 2)
            }
        }
        .padding()
        .onChange(of: viewModel.ampSettings) {
            print(viewModel.ampSettings)
        }
        .border(Color.black)
    }
}

#Preview {
    QMixerChannelView()
}
