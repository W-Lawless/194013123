//
//  PlaneSchematic+Modifiers.swift
//  MyCabin
//
//  Created by Lawless on 5/3/23.
//

import SwiftUI

struct PlaceIcon: ViewModifier {
    var rect: RenderCoordinates
    var subviewWidthUnit: CGFloat
    var subviewHeightUnit: CGFloat
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(Angle(degrees: rect.r))
            .position(x: ((subviewWidthUnit * rect.x) + ((subviewWidthUnit * rect.w)/2)),
                      y: ((subviewHeightUnit * rect.y) + ((subviewHeightUnit * rect.h)/2)) )
        /// Position Center according to API coordinate data & add half the width/height to the coordinate to align image by top left corner
    }
}

struct TappableZone: ViewModifier {
    
    var area: PlaneArea
    @Binding var selectedZone: PlaneArea?
    
    func body(content: Content) -> some View {
        content
            .overlay (
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.white, lineWidth: 1)
            )
            .padding(6)
            .hapticFeedback(feedbackStyle: .rigid) {
                selectedZone = area
                
            }
    }
}


