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

    var body: some View {
        ZStack {
            Text("Climate")
            ForEach(areaClimateZones, id: \.id) { tempZone in
                
                RoundedRectangle(cornerRadius: 4)
                    .stroke(getColor(zone: tempZone), lineWidth: 3)
                    .frame(width: tempZone.rect.w * planeViewModel.subviewWidthUnit, height: tempZone.rect.h * planeViewModel.subviewHeightUnit)
                    .offset(x: 0, y: ((planeViewModel.subviewHeightUnit * tempZone.rect.y) - ((planeViewModel.subviewHeightUnit * tempZone.rect.h)/2)))
//                    .modifier(PlaceIcon(rect: tempZone.rect))
                    .onAppear {
                        print("***", tempZone.id)
                        print("*** ", tempZone.rect)
                        print("*** height", tempZone.rect.h * planeViewModel.subviewHeightUnit)
                    }
                
            } //: FOREACH
            
        } //: ZSTQ
    }
    
    func getColor(zone: ClimateControllerModel) -> Color {
        if(zone.id == "second-temp-ctrl") {
            return .red
        } else {
            return .blue
        }
    }
}
