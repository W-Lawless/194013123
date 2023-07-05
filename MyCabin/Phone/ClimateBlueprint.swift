//
//  ClimateBlueprint.swift
//  MyCabin
//
//  Created by Lawless on 6/22/23.
//

import SwiftUI

struct ClimateBlueprint: View, AreaBlueprint {
    
    @EnvironmentObject var planeViewModel: PlaneViewModel
    let areaClimateZones: [ClimateControllerModel]
    @State var selectedZone: ClimateControllerModel? = nil
    
    var body: some View {
        ZStack {
            ForEach(areaClimateZones.reversed(), id: \.id) { tempZone in
                
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(getColor(tempZone), lineWidth: 1)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(.white.opacity(getOpacity(tempZone)))
                    )
                    .frame(width: getWidth(tempZone), height: getHeight(tempZone))
                    .offset(x: 0, y: getYOffset(tempZone))
                    .hapticFeedback(feedbackStyle: .light) { _ in
                        if(selectedZone == tempZone) {
                            selectedZone = nil
                        } else {
                            selectedZone = tempZone
                        }
                    }
                
            } //: FOREACH
            
        } //: ZSTQ
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.gray.opacity(0.4), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 8))
        
    }
    
    private func getOpacity(_ tempZone: ClimateControllerModel) -> CGFloat {
        selectedZone == tempZone ? 0.4 : 0.001
    }
    
    private func getYOffset(_ tempZone: ClimateControllerModel) -> CGFloat {
        (
            (planeViewModel.subviewHeightUnit * tempZone.rect.y)
            - (
                (planeViewModel.subviewHeightUnit * tempZone.rect.h) / 2
            )
        )
    }
    
    private func getWidth(_ tempZone: ClimateControllerModel) -> CGFloat {
        tempZone.rect.w * planeViewModel.subviewWidthUnit
    }
    
    private func getHeight(_ tempZone: ClimateControllerModel) -> CGFloat {
        tempZone.rect.h * planeViewModel.subviewHeightUnit
    }
    
    private func getColor(_ tempZone: ClimateControllerModel) -> Color {
        if(selectedZone == tempZone) {
            return .white.opacity(0.8)
        } else {
            return .gray.opacity(0.4)
        }
    }
}
