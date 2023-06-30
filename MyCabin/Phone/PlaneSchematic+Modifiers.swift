//
//  PlaneSchematic+Modifiers.swift
//  MyCabin
//
//  Created by Lawless on 5/3/23.
//

import SwiftUI

struct PlaceIcon: ViewModifier {
    @EnvironmentObject var planeViewModel: PlaneViewModel
    var rect: RenderCoordinates
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(Angle(degrees: rect.r))
            .position(x: ((planeViewModel.subviewWidthUnit * rect.x) + ((planeViewModel.subviewWidthUnit * rect.w)/2)),
                      y: ((planeViewModel.subviewHeightUnit * rect.y) + ((planeViewModel.subviewHeightUnit * rect.h)/2)) )
        /// Position Center according to API coordinate data & add half the width/height to the coordinate to align image by top left corner
    }
}

struct TappableClimateZone: ViewModifier {
    @EnvironmentObject var planeViewModel: PlaneViewModel
    var rect: RenderCoordinates
    
    func body(content: Content) -> some View {
        content
            .position(x: ((planeViewModel.subviewWidthUnit * rect.x) + ((planeViewModel.subviewWidthUnit * rect.w)/2)),
                      y: ((planeViewModel.subviewHeightUnit * rect.y) + ((planeViewModel.subviewHeightUnit * rect.h)/2)) )
            .onAppear {
                print("Climate zone drawing")
                print(planeViewModel.plane.parentArea.rect.x)
            }
        /// Position Center according to API coordinate data & add half the width/height to the coordinate to align image by top left corner
    }
}

struct TappableZone: ViewModifier {
    
    @EnvironmentObject var planeViewModel: PlaneViewModel
    var area: PlaneArea
    
    func body(content: Content) -> some View {
        content
            .overlay (
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.white, lineWidth: 1)
                    .accessibilityIdentifier("tappable_\(area.id)")
            )
            .padding(6)
            .hapticFeedback(feedbackStyle: .rigid) { _ in
                print("tapped", area.id)
                planeViewModel.selectedZone = area
            }
    }
}


