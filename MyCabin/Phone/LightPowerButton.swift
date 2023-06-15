//
//  LightPowerButton.swift
//  MyCabin
//
//  Created by Lawless on 12/20/22.
//

import SwiftUI

struct LightPowerButton: View {
    
    @ObservedObject var viewModel = StateFactory.lightsViewModel
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
            StateFactory.apiClient.toggleLight(light, cmd: power ? .ON : .OFF)
        }
    }
}

struct LightPowerButton_Previews: PreviewProvider {
    static var previews: some View {
        let light = LightModel(id: "", name: "lightTest", rect: RenderCoordinates(x: 0.0, y: 0.0, w: 0.0, h: 0.0, r: 0.0), side: "", sub: [], type: "light", brightness: LightBrightness(dimmable: true, range: [0,1]))
        LightPowerButton(light: light)
            .fixedSize()
    }
}
