//
//  Speakers.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/28/22.
//

import SwiftUI

struct Speakers: View {
    
    @StateObject var viewModel: SpeakersViewModel
    var api: SpeakersAPI
    
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
//        .onAppear {
//            api.fetch()
//        }
    }
}


class SpeakersViewModel: ObservableObject {
    
    @Published var loading: Bool = false
    @Published var speakerList: [SpeakerModel]?
    
    func updateValues(_ alive: Bool, _ data: [SpeakerModel]?) {
        self.loading = !alive
        if let data = data {
            print(data[0].state.volume)
            self.speakerList = data
        }
    }
    
    func updateState(for speaker: SpeakerModel) {
        self.speakerList?.mapInPlace({ value in
            if(value.id == speaker.id) {
                print("match", value)
                value = speaker
            }
        })
    }
    
}

struct Speakers_Previews: PreviewProvider {
    static var previews: some View {
        ViewFactories.buildSpeakersView()
    }
}
