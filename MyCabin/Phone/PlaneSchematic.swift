//
//  PlaneSchematic.swift
//  MyCabin
//
//  Created by Lawless on 11/30/22.
//

import SwiftUI

struct PlaneSchematic: View {
    
    @ObservedObject var planeViewModel: PlaneViewModel
        
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack(alignment: .custom) { // ZSTQ
                
                PlaneDisplayOptionBar()
                    .environmentObject(planeViewModel)
                
                HStack(alignment: .center) { // HSTQ

                    Image("plane_left_side")
                        .resizable()
                        .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.6)
                    PlaneFuselage()
                        .environmentObject(planeViewModel)
                    Image("plane_right_side")
                        .resizable()
                        .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.6)
                    
                } //: HSTQ
                .padding(.horizontal, 34)
                .frame(height: geometry.size.height)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                
            } //: ZSTQ
            .padding(.horizontal, 12)
            
        } //: GEO
        .passGeometry { geo in
            planeViewModel.containerWidthUnit = (geo.size.width * 0.39) / planeViewModel.plane.parentArea.rect.w
            planeViewModel.containerHeightUnit = (geo.size.height) / planeViewModel.plane.parentArea.rect.h
        } //: PASS GEO UTIL
        
    } //: BODY
    
}
