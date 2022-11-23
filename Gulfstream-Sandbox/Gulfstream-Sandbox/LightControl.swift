//
//  LightControl.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/23/22.
//

import SwiftUI

struct LightControl: View {
    
//    let light: LightModel
//    var api: LightsAPI

//    @State var sliderValue: Float = 0
    @State var circleOffset: Double = 0
    
    var body: some View {
        VStack{
            
            ZStack {
                Rectangle()
                    .frame(width:300, height: 1)
                
                Rectangle()
                    .frame(width:1, height: 24)
                    .offset(x: -300/2, y: 0)
                
                Rectangle()
                    .frame(width:1, height: 24)
                    .offset(x: -300/4, y: 0)
                
                Rectangle()
                    .frame(width:1, height: 24)
                    .offset(x: 300/2, y: 0)
                
                Rectangle()
                    .frame(width:1, height: 24)
                    .offset(x: 0, y: 0)
                
                Rectangle()
                    .frame(width:1, height: 24)
                    .offset(x: 300/4, y: 0)
                
                Circle()
                    .strokeBorder(Color.white, lineWidth: 1)
                    .background(Circle().fill(Color.black))
//                    .fill(Color.white)
                    .frame(width: 14, height: 14)
                    .offset(x: circleOffset)
                    .gesture(DragGesture().onChanged(dragCircle(value:)))
                
            }
            
        }
//        Slider(value: $sliderValue, in: 0...4)
        
    } //: BODY
    
    func dragCircle(value: DragGesture.Value) {
        let vector = CGVector(dx: value.location.x, dy: value.location.y)
        var xOffset = vector.dx
        
        if (xOffset < (300/2 + 7) && xOffset > (-300/2 - 7)) {
            withAnimation(Animation.linear(duration: 0.1)) { self.circleOffset = xOffset }
        }
    }
}

struct LightControl_Previews: PreviewProvider {
    static var previews: some View {
        LightControl()
    }
}
