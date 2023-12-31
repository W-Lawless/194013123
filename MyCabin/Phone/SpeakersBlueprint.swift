//
//  SpeakersBlueprint.swift
//  MyCabin
//
//  Created by Lawless on 6/22/23.
//

import SwiftUI

struct SpeakersBlueprint: View, AreaBlueprint {
    
    @EnvironmentObject var mediaViewModel: MediaViewModel
    
    let areaSpeakers: [SpeakerModel]
    let speakerButtonBuilder: (SpeakerModel, Bool) -> SpeakerButton
    
    var body: some View {
        ForEach(areaSpeakers) { speaker in
            if(mediaViewModel.selectedSpeakers.contains(speaker)) {
                speakerButtonBuilder(speaker, true)
                    .modifier(PlaceIcon(rect: speaker.rect))
            } else {
                speakerButtonBuilder(speaker, false) //CAPTURES VIEW INTENT AS .SELECTMONITOR AND DOESNT CHANGE
                    .modifier(PlaceIcon(rect: speaker.rect))

            }
        }
    }
}
