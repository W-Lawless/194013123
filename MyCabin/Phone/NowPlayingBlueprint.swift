//
//  NowPlayingBlueprint.swift
//  MyCabin
//
//  Created by Lawless on 6/22/23.
//

import SwiftUI

//TODO: Remove static references

struct NowPlayingBlueprint: View {

    let area: PlaneArea

    @ObservedObject var mediaViewModel = StateFactory.mediaViewModel

    var body: some View {
        ForEach(Array(mediaViewModel.activeMedia.values), id: \.self) { activeMedia in
            
            ActiveMediaButton(area: area, activeMedia: activeMedia)
            
        }
    }
}
