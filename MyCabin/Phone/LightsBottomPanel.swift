//
//  LightsBottomPanel.swift
//  MyCabin
//
//  Created by Lawless on 12/14/22.
//

import SwiftUI

struct LightsBottomPanel: View {
    
    @State var lights = [LightModel]()
    @AppStorage("CurrentSeat") var currentSeat: String = ""
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack{
                Text(currentSeat)
                ForEach(lights) { light in
                    if (light.type == "READ") {
                        Text("\(light.name)")
                    } else {
                        Text("\(light.name)")
                    }
//                    LightControl(light: light)
//                        .background(Color.black)
                } //: FOR EACH
            } //: HSTQ
        } //: SCROLL
        .onAppear {
            getLightsForSeat()
        }
        .onChange(of: currentSeat) { newValue in
            getLightsForSeat()
        }
    }
    
    private func getLightsForSeat() {
        let target = AppFactory.planeElements?.allSeats.filter { seat in
            return seat.id == currentSeat
        }
        
        if let seatLights = target?.first?.lights {
            self.lights = seatLights
        }
    }
    
}

struct LightsBottomPanel_Previews: PreviewProvider {
    static var previews: some View {
        LightsBottomPanel()
    }
}
