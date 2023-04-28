//
//  LightControl.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/23/22.
//

import SwiftUI

struct LightControl: View {
    
    let light: LightModel

    @State var luminosity: Int = 0
    @State var circleOffset: Double = 0
    
    var body: some View {
        VStack{
            
            Button("ON \(light.id)") {
                StateFactory.lightsAPI.toggleLight(light, cmd: .ON)
            }

            Button("OFF \(light.id)") {
                StateFactory.lightsAPI.toggleLight(light, cmd: .OFF)
            }

            Stepper("Brightness", value: $luminosity)

            
//            ZStack {
//                Rectangle()
//                    .frame(width:300, height: 1)
//
//                Rectangle()
//                    .frame(width:1, height: 24)
//                    .offset(x: -300/2, y: 0)
//
//                Rectangle()
//                    .frame(width:1, height: 24)
//                    .offset(x: -300/4, y: 0)
//
//                Rectangle()
//                    .frame(width:1, height: 24)
//                    .offset(x: 300/2, y: 0)
//
//                Rectangle()
//                    .frame(width:1, height: 24)
//                    .offset(x: 0, y: 0)
//
//                Rectangle()
//                    .frame(width:1, height: 24)
//                    .offset(x: 300/4, y: 0)
//
//                Circle()
//                    .strokeBorder(Color.white, lineWidth: 1)
//                    .background(Circle().fill(Color.black))
//                    .frame(width: 14, height: 14)
//                    .offset(x: circleOffset)
//                    .gesture(DragGesture().onChanged(dragCircle(value:)))
//
//            }
            
        }
        
    } //: BODY
    
    func dragCircle(value: DragGesture.Value) {
        let vector = CGVector(dx: value.location.x, dy: value.location.y)
        let xOffset = vector.dx
        
        if (xOffset < ((300/2) + 3.5) && xOffset > ((-300/2) - 7)) {
            withAnimation(Animation.linear(duration: 0.1)) { self.circleOffset = xOffset }
        }
    }
}

//struct LightControl_Previews: PreviewProvider {
//    static var previews: some View {
//        LightControl()
//    }
//}
