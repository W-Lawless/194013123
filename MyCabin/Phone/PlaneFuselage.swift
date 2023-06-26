//
//  PlaneFuselage.swift
//  MyCabin
//
//  Created by Lawless on 6/22/23.
//

import SwiftUI

struct PlaneFuselage: View {
    
    @EnvironmentObject var planeViewModel: PlaneViewModel
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 0) { //VSTQ B
            
            if(planeViewModel.planeDisplayOptions == .tempZones) {
                AreaSubView(area: planeViewModel.plane.parentArea ?? PlaneArea())
                    .environmentObject(planeViewModel)

            } else {
                
                ForEach(planeViewModel.plane.mapAreas) { area in
                    
                    AreaSubView(area: area)
                        .if(planeViewModel.planeDisplayOptions == .lightZones) {
                            $0.modifier(TappableZone(area: area))
                        }
                        .environmentObject(planeViewModel)
                    
                } //: FOREACH
                
            } //: CONDITIONAL
            
        } //: VSTQ B
    }
    
}
