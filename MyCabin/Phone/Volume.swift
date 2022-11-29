//
//  Volume.swift
//  MyCabin
//
//  Created by Lawless on 11/29/22.
//

import SwiftUI

struct Volume: View {
    
    @StateObject var viewModel: VolumeViewModel
    var api: SpeakersAPI
    @State var vol: Int = 0
    
    var body: some View {
        Group {
            if (viewModel.loading) {
                ProgressView()
            } else {
                List(viewModel.speakerList ?? [SpeakerModel]() ) { speaker in
                    VolumeControl(speaker: speaker)
                }
            }
        }.onAppear {
            api.fetch()
        }
    }
}

struct VolumeControl: View {
    var speaker: SpeakerModel
    @State var vol: Int = 0
    
    var body: some View {
        Group {
            Text(speaker.id)
            HStack {
                Text("\(speaker.state.volume)")
                Text(String(describing:$vol.wrappedValue))
                Stepper("Volume", value: $vol)
            }
        }
    }
}


class VolumeViewModel: SpeakersViewModel {
    
//    @Published var loading: Bool = false
//    @Published var speakerList: [SpeakerModel]?
    
//    override func updateValues(_ alive: Bool, _ data: [SpeakerModel]?) {
//        self.loading = !alive
//        if let data = data {
//            self.speakerList = data
//        }
//    }
    
}


struct Volume_Previews: PreviewProvider {
    static var previews: some View {
        ViewFactories.buildVolumeView()
    }
}
