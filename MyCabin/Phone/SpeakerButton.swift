//
//  SpeakerButton.swift
//  MyCabin
//
//  Created by Lawless on 5/5/23.
//

import SwiftUI

struct SpeakerButton: View {
    
    let speaker: SpeakerModel
    @State var selected: Bool
    @ObservedObject var mediaViewModel = StateFactory.mediaViewModel
    
    
    var body: some View {
        Image(selected ? "ic_speaker_on" : "ic_speaker_off")
            .resizable()
            .scaledToFit()
            .frame(maxWidth: 48, maxHeight: 48)
            .scaleEffect(selected ? 1.4 : 1)
            .hapticFeedback(feedbackStyle: .light, cb: mediaViewModel.speakerIconCallback, data: speaker)
    }
}

//struct SpeakerButton_Previews: PreviewProvider {
//    static var previews: some View {
//        SpeakerButton()
//    }
//}
