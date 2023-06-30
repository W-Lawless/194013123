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
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 0) { //VSTQ B
            
            if(planeViewModel.planeDisplayOptions == .tempZones) {

                areaSubViewBuilder(planeViewModel.plane.parentArea)
                    .onAppear {
                        print("*** climate path", planeViewModel.planeDisplayOptions)
                    }

            } else {
                
                ForEach(planeViewModel.plane.mapAreas) { area in
                    areaSubViewBuilder(area)
                        .if(planeViewModel.planeDisplayOptions == .lightZones) {
                            $0.modifier(TappableZone(area: area))
                        }
                    
                } //: FOREACH
                
            } //: CONDITIONAL
            
        } //: VSTQ B
//        .onChange(of: planeViewModel.planeDisplayOptions) { newValue in
//            print("*** >>> redraw")
//        }
    }
    
    private func debug() {
//        dump(planeViewModel.plane.parentArea)
    }
    
}
