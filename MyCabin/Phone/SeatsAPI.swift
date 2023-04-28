//
//  Seats.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/10/22.
//

import Foundation
import Combine

class SeatsAPI {
    
    var viewModel: SeatsViewModel
    
    private let getEndpoint = Endpoint<EndpointFormats.Get, SeatModel>(path: "/api/v1/seats")
    var cancelToken: Cancellable?
    
    init(viewModel: SeatsViewModel) {
        self.viewModel = viewModel
    }
    
    func fetch() {

        let publisher = Session.shared.publisher(for: self.getEndpoint, using: nil)
        
        self.cancelToken = publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    return
                }
            },
            receiveValue: { seats in
                self.viewModel.updateValues(seats)
                FileCacheUtil.cacheToFile(data: seats)

            }
        )
    }

    func call(seat: SeatModel) {
        
        let endpoint = Endpoint<EndpointFormats.Put<SeatModel.state>, SeatModel.state>(path: "/api/v1/seats/\(seat.id)/state")
        let encodeObj = SeatModel.state(call: true, identifier: seat.id)
        
        let publisher = Session.shared.publisher(for: endpoint, using: encodeObj)
        
        self.cancelToken = publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    print("Put request made")
                    return
                }
            },
            receiveValue: { seats in
                    print("put request data", seats)
            }
        )
    }
}
