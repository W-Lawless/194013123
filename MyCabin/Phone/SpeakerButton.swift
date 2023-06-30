//
//  SpeakerButton.swift
//  MyCabin
//
//  Created by Lawless on 5/5/23.
//

import SwiftUI

struct SpeakerButton: View {
    
    @EnvironmentObject var mediaViewModel: MediaViewModel
    let speaker: SpeakerModel
    @State var selected: Bool
    
    let iconCallback: (SpeakerModel) -> Void
    
    var body: some View {
        Image(selected ? "ic_speaker_on" : "ic_speaker_off")
            .resizable()
            .scaledToFit()
            .frame(maxWidth: 42, maxHeight: 42)
            .scaleEffect(selected ? 1.1 : 1)
            .accessibilityIdentifier(speaker.id)
            .hapticFeedback(feedbackStyle: .light) { _ in
                iconCallback(speaker)
            }
    }
}
