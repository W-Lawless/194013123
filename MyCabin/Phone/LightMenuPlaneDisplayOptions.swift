//
//  LightMenuPlaneDisplayOptions.swift
//  MyCabin
//
//  Created by Lawless on 6/22/23.
//

import SwiftUI

struct LightMenuPlaneDisplayOptions: View {
    
    @EnvironmentObject var planeViewModel: PlaneViewModel
    
    var body: some View {
        VStack(spacing: 32) {
            
            LightMenuOptionButton(targetOption: .lightZones, imageName: "square.on.square")
            LightMenuOptionButton(targetOption: .showLights, imageName: "lightbulb.fill")
            
        }
        .padding(.horizontal, 18)
    }
    
}

//TODO: - Viewbuilder 'Plane Display Option Button' button
struct LightMenuOptionButton: View {
  
    @EnvironmentObject var planeViewModel: PlaneViewModel
    let targetOption: PlaneSchematicDisplayMode
    let imageName: String
    
    var body: some View {
        Button {
            planeViewModel.updateDisplayMode(targetOption)
        } label: {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .frame(width: 24, height: 24)
                .overlay (
                    RoundedRectangle(cornerRadius: 6).stroke(.blue, lineWidth: 1).frame(width: 48, height: 48)
                )
        }
        .accessibilityIdentifier("\(targetOption)")
    }
}
