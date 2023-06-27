//
//  PlaneDisplayOptionBar.swift
//  MyCabin
//
//  Created by Lawless on 6/22/23.
//

import SwiftUI

struct PlaneDisplayOptionBar: View {
    
    let planeDisplayOptions: PlaneSchematicDisplayMode
    
    var body: some View {
        if (planeDisplayOptions == .showLights || planeDisplayOptions == .lightZones) {
            LightMenuPlaneDisplayOptions()
        }
        
        if(planeDisplayOptions == .showShades) {
            ShadeMenuPlaneDisplayOptions()
        }
    }
}
