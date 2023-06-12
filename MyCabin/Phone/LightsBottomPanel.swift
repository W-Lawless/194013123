//
//  LightsBottomPanel.swift
//  MyCabin
//
//  Created by Lawless on 12/14/22.
//

import SwiftUI

struct LightsBottomPanel: View {
    
    @ObservedObject var viewModel: LightsViewModel = StateFactory.lightsViewModel
    @State var lights = [LightModel]()
    
    var body: some View {
        
        GeometryReader { geo in
            
            ScrollView(.horizontal, showsIndicators: false) {
            
          
                HStack(alignment: .center, spacing: 12) {
                    ForEach(Array(lights.enumerated()), id: \.element) { index, element in
                        if(lights[index].brightness.dimmable){
                            AdjustablePowerButton(light: lights[index])
                        } else {
                            LightPowerButton(light: lights[index])
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                }
                .border(.red, width: 2)
                
                
            } //: SCROLL
            .frame(width: geo.size.width, height: geo.size.height, alignment: .top)
            
        }  //: GEO
        .onAppear {
            getLightsForSeat()
 //            print(lights)
        }
        .onChange(of: viewModel.activeSeat) { newValue in
            getLightsForSeat()
        }
    }
    
    private func getLightsForSeat() {
        let target = PlaneFactory.planeViewModel.plane.allSeats.filter { seat in
            return seat.id == viewModel.activeSeat
        }

        if let seatLights = target.first?.lights {
            self.lights = seatLights
        }
    }
}

struct LightsBottomPanel_Previews: PreviewProvider {
    static var previews: some View {
        LightsBottomPanel()
    }
}

