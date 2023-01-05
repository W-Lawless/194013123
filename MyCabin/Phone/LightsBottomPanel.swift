//
//  LightsBottomPanel.swift
//  MyCabin
//
//  Created by Lawless on 12/14/22.
//

import SwiftUI

struct LightsBottomPanel: View {
    
    @State var lights = [LightModel]()
    @State var showDimmable: Bool = false
    @AppStorage("CurrentSeat") var currentSeat: String = ""
    
    var body: some View {
        
        GeometryReader { geo in
            
            ScrollView(.horizontal, showsIndicators: false) {
            
                if(showDimmable){
                    AdjustablePowerButton(light: lights[0], display: $showDimmable)
                } else {
                    HStack(spacing: 18) {
                        ForEach(Array(lights.enumerated()), id: \.element) { index, element in
                            if(lights[index].brightness.dimmable){
                                AdjustablePowerButton(light: lights[index], display: $showDimmable)
                            } else {
                                LightPowerButton(light: lights[index])
                            }
                        }
                    }
                    .frame(width:geo.size.width, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                }
                
                
            } //: SCROLL
            .frame(width: geo.size.width, height: geo.size.height, alignment: .top)
            
        }  //: GEO
        .onAppear {
            getLightsForSeat()
            print(lights)
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
