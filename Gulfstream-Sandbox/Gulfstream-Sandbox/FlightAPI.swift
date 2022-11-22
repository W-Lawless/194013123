//
//  FlightInterface.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/21/22.
//

import Foundation
import Combine

class FlightAPI {
    
    let viewModel: FlightViewModel
    let monitor = HeartBeatMonitor()
    
    private let endpoint = Endpoint<EndpointFormats.Get, FlightModel>(path: "/api/v1/flightInfo")
    var cancelToken: Cancellable?
    
    init(viewModel: FlightViewModel) {
        self.viewModel = viewModel
    }
    
    func fetch() {
        let publisher = Session.shared.publisher(for: self.endpoint, using: nil)
        
        self.cancelToken = publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    print()
                }
            },
            receiveValue: { shades in
                self.viewModel.updateValues(true, shades[0])
            }
        )
    }
    
    func monitorCallback() {
        fetch()
    }
}
