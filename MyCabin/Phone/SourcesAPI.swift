//
//  SourcesAPI.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/28/22.
//

import Combine


class SourcesAPI {
    
    let viewModel: SourcesViewModel
    var cancelToken: Cancellable?

    let endpoint = Endpoint<EndpointFormats.Get, SourceModel>(path: "/api/v1/sources")
    
    init(viewModel: SourcesViewModel) {
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
            receiveValue: { sources in
                self.viewModel.updateValues(true, sources)
                FileCacheUtil.cacheToFile(data: sources)
            }
        )
    }
}


