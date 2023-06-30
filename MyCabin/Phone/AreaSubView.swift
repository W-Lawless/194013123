//
//  AreaSubView.swift
//  MyCabin
//
//  Created by Lawless on 5/4/23.
//

import SwiftUI


struct AreaSubView: View {
    
    @EnvironmentObject var planeViewModel: PlaneViewModel

    let area: PlaneArea
    let baseBlueprintBuilder: (PlaneArea) -> AreaBaseBlueprint
    let featureBlueprintBuilder: (PlaneArea, PlaneSchematicDisplayMode) -> AnyView
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            baseBlueprintBuilder(area)
            featureBlueprintBuilder(area, planeViewModel.planeDisplayOptions)
            //TODO: - Feature Blueprint double draws on lights / seats menu

        }
        .frame(width: (planeViewModel.subviewWidthUnit * area.rect.w), height: (planeViewModel.subviewHeightUnit * area.rect.h))
        .onAppear {
//            if(planeViewModel.planeDisplayOptions != .onlySeats) {
                print("**", area.id)
//            }
//            dump(area.rect)
            calculateAreaCoorindates()
        }
        .if(isZoneDisplayMode()) { view in
            view
                .opacity(planeViewModel.selectedZone?.id == area.id ? 1 : 0.3)
                .background(planeViewModel.selectedZone?.id == area.id ? Color.yellow.opacity(0.3) : nil)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }

    }
    
    private func isZoneDisplayMode() -> Bool {
        if (planeViewModel.planeDisplayOptions == .tempZones || planeViewModel.planeDisplayOptions == .lightZones) {
            return true
        } else {
            return false
        }
    }
    
    private func calculateAreaCoorindates() {
        let subviewHeight = planeViewModel.containerHeightUnit * area.rect.h
        planeViewModel.subviewHeightUnit = subviewHeight / area.rect.h
        
        let subviewWidth = planeViewModel.containerWidthUnit * area.rect.w
        planeViewModel.subviewWidthUnit = subviewWidth / area.rect.w
    }
    
}
