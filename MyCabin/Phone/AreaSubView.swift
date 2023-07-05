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
    
    var areaWidthInPoints: CGFloat {
        if (area.id != "") {
            return planeViewModel.subviewWidthUnit * area.rect.w
        } else {
            return  planeViewModel.widthOfAllAreas
        }
    }
    
    var areaHeightInPoints: CGFloat {
        if (area.id != "") {
            return planeViewModel.subviewHeightUnit * area.rect.h
        } else {
            return planeViewModel.heightOfAllAreas
        }
    }
    
    var body: some View {
            ZStack(alignment: .topLeading) {
                baseBlueprintBuilder(area)
                featureBlueprintBuilder(area, planeViewModel.planeDisplayOptions)
                //TODO: - Feature Blueprint double draws on lights / seats menu
                
            }
            .frame(width: areaWidthInPoints, height: areaHeightInPoints)
            .if(isZoneDisplayMode()) { view in
                view
                    .opacity(planeViewModel.selectedZone?.id == area.id ? 1 : 0.3)
                    .background(planeViewModel.selectedZone?.id == area.id ? Color.yellow.opacity(0.3) : nil)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        
    }
    
    private func isZoneDisplayMode() -> Bool {
        if (planeViewModel.planeDisplayOptions == .lightZones) {
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
