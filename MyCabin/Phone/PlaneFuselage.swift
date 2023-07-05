//
//  PlaneFuselage.swift
//  MyCabin
//
//  Created by Lawless on 6/22/23.
//

import SwiftUI

struct PlaneFuselage: View {
    @EnvironmentObject var planeViewModel: PlaneViewModel
    
    let areaSubViewBuilder: (PlaneArea) -> AreaSubView
    let climateOverlayBuilder: () -> ClimateBlueprint
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 0) { //VSTQ B
            
            loadContent()
            
        }
    }
    
}

extension PlaneFuselage {
    @ViewBuilder func loadContent() -> some View {
        
        ZStack {
            
            VStack(spacing:0) {
                
                ForEach(planeViewModel.plane.mapAreas) { area in
                    areaSubViewBuilder(area)
                        .if(planeViewModel.planeDisplayOptions == .lightZones) {
                            $0.modifier(TappableZone(area: area))
                        }
                }
            }
            
            if(planeViewModel.planeDisplayOptions == .tempZones) {
                climateOverlayBuilder()
            }
            
        }
        
    }
}
