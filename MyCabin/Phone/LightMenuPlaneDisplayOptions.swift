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
            
            LightMenuOptionButton(viewModel: planeViewModel, targetOption: .lightZones, imageName: "square.on.square")
            LightMenuOptionButton(viewModel: planeViewModel, targetOption: .showLights, imageName: "lightbulb.fill")
            
        }
        .padding(.horizontal, 18)
    }
    
}

struct LightMenuOptionButton: View {
  
    let viewModel: PlaneViewModel
    let targetOption: PlaneSchematicDisplayMode
    let imageName: String
    
    var body: some View {
        Button {
            viewModel.updateDisplayMode(targetOption)
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
