//
//  ClimateBlueprint.swift
//  MyCabin
//
//  Created by Lawless on 6/22/23.
//

import SwiftUI

struct ClimateBlueprint: View {

    @EnvironmentObject var planeViewModel: PlaneViewModel
    let area: PlaneArea

    var body: some View {
        ZStack {
            ForEach(Array(area.zoneTemp ?? [ClimateControllerModel]()), id: \.self) { tempZone in
                
                RoundedRectangle(cornerRadius: 4)
                    .stroke(.red, lineWidth: 1)
                    .frame(width: tempZone.rect.w * planeViewModel.subviewWidthUnit, height: tempZone.rect.h * planeViewModel.subviewHeightUnit)
//                    .modifier(PlaceIcon(rect: tempZone.rect, subviewWidthUnit: subviewWidthUnit, subviewHeightUnit: subviewHeightUnit))
                
            } //: FOREACH
            
        } //: ZSTQ
    }
}
