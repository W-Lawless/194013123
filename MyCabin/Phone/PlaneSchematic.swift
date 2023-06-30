//
//  PlaneSchematic.swift
//  MyCabin
//
//  Created by Lawless on 11/30/22.
//

import SwiftUI

struct PlaneSchematic: View {
    
    @ObservedObject var planeViewModel: PlaneViewModel
    @ObservedObject var mediaViewModel: MediaViewModel
    
    let planeDisplayOptionsBarBuilder: (PlaneSchematicDisplayMode) -> AnyView
    let planeFuselageBuilder: () -> PlaneFuselage
        
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack(alignment: .custom) { // ZSTQ
                
                planeDisplayOptionsBarBuilder(planeViewModel.planeDisplayOptions)
                
                HStack(alignment: .center) { // HSTQ

                    Image("plane_left_side")
                        .resizable()
                        .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.6)
                    
                    planeFuselageBuilder()
                        .onAppear {
                            print("*** plane fuselage built")
                        }
                    
                    Image("plane_right_side")
                        .resizable()
                        .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.6)

                } //: HSTQ
                .padding(.horizontal, 34)
                .frame(height: geometry.size.height)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                
            } //: ZSTQ
            .padding(.horizontal, 12)
            .environmentObject(planeViewModel)
            .environmentObject(mediaViewModel) // Since the plane schematic is shared between screens that both do/don't use a media reference, always needed in env to avoid crash
            
        } //: GEO
        .passGeometry { geo in
            planeViewModel.containerWidthUnit = (geo.size.width * 0.39) / planeViewModel.plane.parentArea.rect.w
            planeViewModel.containerHeightUnit = (geo.size.height) / planeViewModel.plane.parentArea.rect.h
        } //: PASS GEO UTIL
        
    } //: BODY
    
}
