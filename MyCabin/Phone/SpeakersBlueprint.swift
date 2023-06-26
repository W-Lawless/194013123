//
//  SpeakersBlueprint.swift
//  MyCabin
//
//  Created by Lawless on 6/22/23.
//

import SwiftUI

//TODO: Remove static references

struct SpeakersBlueprint: View {
    
    let area: PlaneArea
    
    @ObservedObject var mediaViewModel = StateFactory.mediaViewModel
    
    var body: some View {
        ForEach(area.speakers ?? [SpeakerModel]()) { speaker in
            if(speaker.id == mediaViewModel.selectedSpeaker) {
                SpeakerButton(speaker: speaker, selected: true)
                    .modifier(PlaceIcon(rect: speaker.rect))
            } else {
                SpeakerButton(speaker: speaker, selected: false)
                    .modifier(PlaceIcon(rect: speaker.rect))
            }
        }
    }
}
