//
//  LightPowerButton.swift
//  MyCabin
//
//  Created by Lawless on 12/20/22.
//

import SwiftUI

struct LightPowerButton: View {
    
    @EnvironmentObject var viewModel: LightsViewModel
    
    let apiClient: GCMSClient
    
    @State var light: LightModel
    @State var power: Bool = false
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(power ? Color.green : Color.black)
                    .frame(width:48, height: 50)
                    .overlay (
                        Circle()
                            .stroke(Color.white, lineWidth: 1)
                    )
                Image(systemName: "power")
                    .foregroundColor(.white)
            }
            Text(light.name)
                .font(.caption2)
        }
        .onAppear{
            print("CURRENT STATE ON PLANE:",viewModel.rtResponses[light.id] ?? "none")
            if let lightState = viewModel.rtResponses[light.id] {
                print("IT IS:",lightState.on)
                power = lightState.on
            }
        }
        .onChange(of: viewModel.rtResponses[light.id], perform: { newValue in
            print("VALUE CHANGED ON PLANE:", newValue ?? "optionalwrapped")
            power = newValue?.on ?? false
        })
        .frame(width: 64)
        .hapticFeedback(feedbackStyle: .rigid) { _ in
            power.toggle()
            apiClient.toggleLight(light, cmd: power ? .ON : .OFF)
        }
    }
}
