//
//  PlaneDisplayOptionBar.swift
//  MyCabin
//
//  Created by Lawless on 6/22/23.
//

import SwiftUI

struct PlaneDisplayOptionBar: View {
    
    @EnvironmentObject var planeViewModel: PlaneViewModel
    
    var body: some View {
        if (planeViewModel.planeDisplayOptions == .showLights || planeViewModel.planeDisplayOptions == .lightZones) {
            LightMenuPlaneDisplayOptions()
                .environmentObject(planeViewModel)
        }
        
        if(planeViewModel.planeDisplayOptions == .showShades) {
            ShadeMenuPlaneDisplayOptions()
        }
    }
}
