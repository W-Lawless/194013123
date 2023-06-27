//
//  ShadeBlueprint.swift
//  MyCabin
//
//  Created by Lawless on 6/22/23.
//

import SwiftUI

struct ShadeBlueprint: View, AreaBlueprint {
    
    let area: PlaneArea
    let shadeButtonBuilder: (ShadeModel) -> ShadeButton
    
    var body: some View {
        ForEach(area.shades ?? [ShadeModel]()) { shade in
            shadeButtonBuilder(shade)
                .modifier(PlaceIcon(rect: shade.rect))
        } //: FOR EACH
    }
}
