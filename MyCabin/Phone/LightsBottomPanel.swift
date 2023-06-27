//
//  LightsBottomPanel.swift
//  MyCabin
//
//  Created by Lawless on 12/14/22.
//

import SwiftUI

struct LightsBottomPanel: View {
    
    @EnvironmentObject var viewModel: LightsViewModel
    
    let adjustablePowerButtonBuilder: (LightModel) -> AdjustablePowerButton
    let lightPowerButtonBuilder: (LightModel) -> LightPowerButton
    
    var body: some View {
        
        GeometryReader { geo in
            
            ScrollView(.horizontal, showsIndicators: false) {
            
                HStack(alignment: .center, spacing: 12) {
                    ForEach(Array(viewModel.lightsForSeat.enumerated()), id: \.element) { index, element in
                        if(viewModel.lightsForSeat[index].brightness.dimmable){
                            adjustablePowerButtonBuilder(viewModel.lightsForSeat[index])
                        } else {
                            lightPowerButtonBuilder(viewModel.lightsForSeat[index])
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                }                
                
            } //: SCROLL
            .accessibilityIdentifier("lightControlPanel")
            .frame(width: geo.size.width, height: geo.size.height, alignment: .top)
            
        }  //: GEO
        .onAppear {
//            print("APPEAR!")
            viewModel.getLightsForSeat()
            viewModel.pollLightsForState(lights: viewModel.lightsForSeat)
        }
        .onChange(of: viewModel.activeSeat) { newValue in
            viewModel.killMonitor()
            viewModel.getLightsForSeat()
            viewModel.pollLightsForState(lights: viewModel.lightsForSeat)
        }
        .onDisappear {
//            print("GOODBYE")
            viewModel.killMonitor()
//            print(viewModel.rtResponses)
        }
    }

}
