//
//  PlaneSchematic.swift
//  MyCabin
//
//  Created by Lawless on 11/30/22.
//

import SwiftUI

struct PlaneSchematic<OptionBar: View, Fuselage: View>: View {
    
    @ObservedObject var planeViewModel: PlaneViewModel
    @ObservedObject var mediaViewModel: MediaViewModel
    
    let planeDisplayOptionsBar: () -> OptionBar
    let planeFuselage: () -> Fuselage
        
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack(alignment: .custom) { // ZSTQ
                
                planeDisplayOptionsBar()
                
                HStack(alignment: .center) { // HSTQ

                    PlaneWing(image: "plane_left_side", width: geometry.size.width * 0.15, height: geometry.size.height * 0.6)
                    
                    planeFuselage()
                        .frame(width: planeViewModel.widthOfAllAreas, height: planeViewModel.heightOfAllAreas)
                    
                    PlaneWing(image: "plane_right_side", width: geometry.size.width * 0.15, height: geometry.size.height * 0.6)

                } //: HSTQ
                .frame(width: geometry.size.width)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                
            } //: ZSTQ
            .padding(.horizontal, geometry.size.width * 0.03)
            .environmentObject(planeViewModel)
            .environmentObject(mediaViewModel) // Since the plane schematic is shared between screens that both do/don't use a media reference, always needed in env to avoid crash
            
        } //: GEO
//        .passGeometry { geo in
////            planeViewModel.containerWidthUnit = (geo.size.width * 0.39) / planeViewModel.plane.parentArea.rect.w
////            planeViewModel.containerHeightUnit = (geo.size.height) / planeViewModel.plane.parentArea.rect.h
//        } //: PASS GEO UTIL
        
    } //: BODY
    
}

struct PlaneWing: View {
   
    let image: String
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        Image(image)
            .resizable()
            .frame(width: width, height: height)
    }
    
}
