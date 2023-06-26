//
//  Speakers.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/28/22.
//

import SwiftUI

struct Speakers: View {
    
    @StateObject var viewModel: SpeakersViewModel
    
    var body: some View {
        Group {
            if (viewModel.loading) {
                ProgressView()
            } else {
                List(viewModel.speakerList ?? [SpeakerModel]() ) { speaker in
                    Group {
                        Text(speaker.id)
                        Text("\(speaker.state.volume)")
                    }
                }
            }
        }
    }
}


class SpeakersViewModel: ObservableObject, GCMSViewModel {
    
    @Published var loading: Bool = false
    @Published var speakerList: [SpeakerModel]?
    @Published var playingSpeakers: [String:String] = ["-":"-"]
    
    func updateValues(_ data: [Codable]) {
        self.speakerList = data as? [SpeakerModel]
    }
    
    func updateState(for speaker: SpeakerModel) {
        self.speakerList?.mapInPlace({ value in
            if(value.id == speaker.id) {
                value = speaker
            }
        })
    }
    
}

