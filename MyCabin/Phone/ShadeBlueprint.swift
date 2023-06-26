//
//  ShadeBlueprint.swift
//  MyCabin
//
//  Created by Lawless on 6/22/23.
//

import SwiftUI

struct ShadeBlueprint: View {
    
    let area: PlaneArea
    
    var body: some View {
        ForEach(area.shades ?? [ShadeModel]()) { shade in
            ShadeButton(shade: shade)
                .modifier(PlaceIcon(rect: shade.rect))
        } //: FOR EACH
    }
}
