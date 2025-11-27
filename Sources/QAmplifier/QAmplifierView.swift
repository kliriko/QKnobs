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
        HStack(spacing: 40) {
            VStack {
                Text("Gain")
                    .font(.headline)
                QRadialKnobView(viewModel: viewModel.gain)
                    .frame(width: 120, height: 120)
            }
            
            VStack {
                Text("Bass")
                    .font(.headline)
                QRadialKnobView(viewModel: viewModel.bass)
                    .frame(width: 120, height: 120)
            }
            
            VStack {
                Text("Mid")
                    .font(.headline)
                QRadialKnobView(viewModel: viewModel.mid)
                    .frame(width: 120, height: 120)
            }
            
            VStack {
                Text("Treble")
                    .font(.headline)
                QRadialKnobView(viewModel: viewModel.treble)
                    .frame(width: 120, height: 120)
            }
            
            VStack {
                Text("Presence")
                    .font(.headline)
                QRadialKnobView(viewModel: viewModel.presence)
                    .frame(width: 120, height: 120)
            }
            
            VStack {
                Text("Volume")
                    .font(.headline)
                QFaderView(viewModel: viewModel.volume)
                    .frame(width: 60, height: 300)
            }
        }
        .padding()
        .onChange(of: viewModel.ampSettings) {
            print(viewModel.ampSettings)
        }
    }
}
