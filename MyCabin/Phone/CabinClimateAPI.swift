//
//  ClimateAPI.swift
//  MyCabin
//
//  Created by Lawless on 11/29/22.

import Combine

class CabinClimateAPI {
    
    var viewModel: CabinClimateViewModel
    
    private let getEndpoint = Endpoint<EndpointFormats.Get, ClimateControllerModel>(path: "/api/v1/tempcntrls")
    var cancelToken: Cancellable?
    
    init(viewModel: CabinClimateViewModel) {
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
            receiveValue: { climateReadings in
                self.viewModel.updateValues(true, data: climateReadings)
            }
        )
    }

    /*func call(seat: SeatModel) {
        
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
    }*/
}
