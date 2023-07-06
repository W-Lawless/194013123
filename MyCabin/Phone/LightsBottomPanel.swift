//
//  LightsBottomPanel.swift
//  MyCabin
//
//  Created by Lawless on 12/14/22.
//

import SwiftUI

struct LightsBottomPanel<AdjustableButton: View, PowerButton: View>: View {
    
    @EnvironmentObject var viewModel: LightsViewModel
    
    let adjustablePowerButton: (LightModel) -> AdjustableButton
    let lightPowerButton: (LightModel) -> PowerButton
    
    var body: some View {
        
        GeometryReader { geo in
            
            ScrollView(.horizontal, showsIndicators: false) {
            
                HStack(alignment: .center, spacing: 12) {
                    
                    ForEach(Array(viewModel.lightsForSeat.enumerated()), id: \.element) { index, element in
                    
                        if(viewModel.lightsForSeat[index].brightness.dimmable){
                            
                            adjustablePowerButton(viewModel.lightsForSeat[index])
                            
                        } else {
                            
                            lightPowerButton(viewModel.lightsForSeat[index])
                            
                        }
                        
                    } //: FOREACH
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                    
                } //: HSTQ
                
            } //: SCROLL
            .accessibilityIdentifier("lightControlPanel")
            .frame(width: geo.size.width, height: geo.size.height, alignment: .top)
            
        }  //: GEO
        .onAppear {
            viewModel.getLightsForSeat()
            viewModel.pollLightsForState(lights: viewModel.lightsForSeat)
        }
        .onChange(of: viewModel.activeSeat) { newValue in
            viewModel.killMonitor()
            viewModel.getLightsForSeat()
            viewModel.pollLightsForState(lights: viewModel.lightsForSeat)
        }
        .onDisappear {
            viewModel.killMonitor()
        }
    }

}
