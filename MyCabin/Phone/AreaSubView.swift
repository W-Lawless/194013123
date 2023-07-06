//
//  AreaSubView.swift
//  MyCabin
//
//  Created by Lawless on 5/4/23.
//

import SwiftUI


struct AreaSubView<Content: View>: View {
    
    @EnvironmentObject var planeViewModel: PlaneViewModel //Needs ref to trigger re-paint on context updates
    
    let zStackWithContent: () -> Content
    
    var body: some View {
        zStackWithContent()
    }
    
//TODO: - ref
//    private func calculateAreaCoorindates() {
//        let subviewHeight = planeViewModel.containerHeightUnit * area.rect.h
//        planeViewModel.subviewHeightUnit = subviewHeight / area.rect.h
//
//        let subviewWidth = planeViewModel.containerWidthUnit * area.rect.w
//        planeViewModel.subviewWidthUnit = subviewWidth / area.rect.w
//    }
    
}
