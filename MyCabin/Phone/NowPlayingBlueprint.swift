//
//  NowPlayingBlueprint.swift
//  MyCabin
//
//  Created by Lawless on 6/22/23.
//

import SwiftUI

struct NowPlayingBlueprint: View, AreaBlueprint {

    @EnvironmentObject var activeMediaViewModel: ActiveMediaViewModel
    
    let area: PlaneArea
    let activeMediaButtonGroupBuilder: (PlaneArea, ActiveMedia) -> ActiveMediaButtonGroup

    var body: some View {
        
        ForEach(Array(activeMediaViewModel.activeMedia.values), id: \.self) { activeMedia in
            activeMediaButtonGroupBuilder(area, activeMedia)
        }
        
    }
}
