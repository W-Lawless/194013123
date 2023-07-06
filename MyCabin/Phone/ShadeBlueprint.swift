//
//  ShadeBlueprint.swift
//  MyCabin
//
//  Created by Lawless on 6/22/23.
//

import SwiftUI

struct ShadeBlueprint<ShadeBtn: View>: View, AreaBlueprint {
    
    let area: PlaneArea
    let shadeButton: (ShadeModel) -> ShadeBtn
    
    var body: some View {
        ForEach(area.shades ?? [ShadeModel]()) { shade in
            shadeButton(shade)
                .modifier(PlaceIcon(rect: shade.rect))
        } //: FOR EACH
    }
}
