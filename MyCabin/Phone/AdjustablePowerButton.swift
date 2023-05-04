//
//  AdjustablePowerButton.swift
//  MyCabin
//
//  Created by Lawless on 1/2/23.
//

import SwiftUI

struct AdjustablePowerButton: View {
    @State var light: LightModel
    @Binding var display: Bool
    @State var power:Bool = false
    @State var luminosity:Int = 0
    
    var body: some View {
        if(display) {
            VStack{
                Toggle(isOn: $power) {
                    Text("Power")
                }
                .onChange(of: power) { newValue in
                    StateFactory.apiClient.toggleLight(light, cmd: newValue ? .ON : .OFF)
                }
                Stepper("Brightness", value: $luminosity)
            }
        } else {
            VStack {
                ZStack {
                    Circle()
                        .fill(display ? Color.green : Color.black)
                        .frame(width:48, height: 50)
                        .overlay (
                            Circle()
                                .stroke(Color.white, lineWidth: 1)
                        )
                    Image(systemName: "power")
                        .foregroundColor(.white)
                }
                Text("Dimmable \(light.name)")
                    .font(.caption2)
            }
            .frame(width: 64)
            .hapticFeedback(feedbackStyle: .rigid) {
                display.toggle()
            }
        }
    }
//    }
}

//struct AdjustablePowerButton_Previews: PreviewProvider {
//    static var previews: some View {
//        @State var display: Bool = false
//        let light = LightModel(id: "", name: "lightTest", rect: RenderCoordinates(x: 0.0, y: 0.0, w: 0.0, h: 0.0, r: 0.0), side: "", sub: [], type: "light", brightness: LightBrightness(dimmable: true, range: [0,1]))
//        AdjustablePowerButton(light: light, display: display)
//            .fixedSize()
//    }
//}
