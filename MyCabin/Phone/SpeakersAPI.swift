//
//  SpeakersAPI.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/28/22.
//

import Combine


class SpeakersAPI {
    
    let viewModel: SpeakersViewModel
    var cancelToken: Cancellable?

    let endpoint = Endpoint<EndpointFormats.Get, SpeakerModel>(path: "/api/v1/speakers")
    
    init(viewModel: SpeakersViewModel) {
        self.viewModel = viewModel
    }
    
    func fetch() {
        let publisher = Session.shared.publisher(for: endpoint, using: nil)
        
        self.cancelToken = publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    return
                }
            },
            receiveValue: { speakers in
                self.viewModel.updateValues(true, speakers)
                FileCacheUtil.cacheToFile(data: speakers)
            }
        )
    }
}
