//
//  AdjustablePowerButton.swift
//  MyCabin
//
//  Created by Lawless on 1/2/23.
//

import SwiftUI

struct AdjustablePowerButton: View {
    @State var light: LightModel
    @State var power:Bool = false
    @State var luminosity:Int = 50
    
    var body: some View {
//        if(display) {
            VStack{
                Toggle(isOn: $power) {
                    Text("Power")
                }
                .onChange(of: power) { newValue in
                    print("power::",power)
                    StateFactory.apiClient.toggleLight(light, cmd: newValue ? .ON : .OFF)
                }
                Stepper("Brightness", value: $luminosity, in: 0...100, step: 25).onChange(of: luminosity) { newValue in
                    print("lumisotry is", newValue)
                    StateFactory.apiClient.adjustBrightness(light, brightness: luminosity)
                }
//                Stepper("Brightness") {
//                    print(luminosity)
//                    if luminosity < 100 {
//                        luminosity += 5
//                    }
//                    print(luminosity)

//                } onDecrement: {
//                    print(luminosity)
//                    if luminosity > 0 {
//                        luminosity -= 5
//                    }
//                    print(luminosity)
////                    StateFactory.apiClient.adjustBrightness(light, brightness: luminosity)
//                }

            }
//        } else {
        
//            VStack {
//                ZStack {
//                    Circle()
//                        .fill(power ? Color.green : Color.black)
//                        .frame(width:48, height: 50)
//                        .overlay (
//                            Circle()
//                                .stroke(Color.white, lineWidth: 1)
//                        )
//                    Image(systemName: "power")
//                        .foregroundColor(.white)
//                }
//                Text("Dimmable \(light.name)")
//                    .font(.caption2)
//            }
//            .frame(width: 64)
//            .hapticFeedback(feedbackStyle: .rigid) { _ in
//                power.toggle()
//            }
        
//        }
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