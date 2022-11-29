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
                        Text(speaker.name)
                    }
                }
            }
        }.onAppear {
            api.fetch()
        }
    }
}


class SpeakersViewModel: ObservableObject {
    
    @Published var loading: Bool = false
    @Published var speakerList: [SpeakerModel]?
    
    func updateValues(_ alive: Bool, _ data: [SpeakerModel]?) {
        print("updating values with data")
        self.loading = !alive
        if let data = data {
            self.speakerList = data
        }
    }
    
}

struct Speakers_Previews: PreviewProvider {
    static var previews: some View {
        ViewFactories.buildSpeakersView()
    }
}