//
//  NowPlayingBlueprint.swift
//  MyCabin
//
//  Created by Lawless on 6/22/23.
//

import SwiftUI

//TODO: Remove static references

struct NowPlayingBlueprint: View, AreaBlueprint {

    @EnvironmentObject var mediaViewModel: MediaViewModel //= StateFactory.mediaViewModel

    let area: PlaneArea
    let activeMediaButtonBuilder: (PlaneArea, ActiveMedia) -> ActiveMediaButton

    var body: some View {
        ForEach(Array(mediaViewModel.activeMedia.values), id: \.self) { activeMedia in
            
            activeMediaButtonBuilder(area, activeMedia)
            
        }
    }
}
