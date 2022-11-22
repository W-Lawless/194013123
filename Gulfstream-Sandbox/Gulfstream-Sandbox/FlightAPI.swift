//
//  FlightInterface.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/21/22.
//

import Foundation
import Combine

//MARK: - API

class FlightAPI {
    
    var viewModel: FlightViewModel
    let monitor = HeartBeatMonitor()
    
    private let scheme = "http"
    private let host = "10.0.0.41"
    private let baseApi = "/api/v1/flightInfo"
    private var endpoint: URL
    private let endpoint2 = Endpoint<EndpointFormats.Get, FlightModel>(path: "/api/v1/flightInfo")
    var cancelToken: Cancellable?
    
    init(viewModel: FlightViewModel) {
        var URI = URLComponents()
        URI.scheme = self.scheme
        URI.host = self.host
        URI.path = "\(self.baseApi)"
        self.endpoint = URI.url!
        self.viewModel = viewModel
    }
    
    func fetch() {
        let publisher = Session.shared.publisher(for: self.endpoint2, using: nil)
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
                Task {
                    await self.viewModel.updateValues(true, shades[0])
                }
            }
        )
    }
    
    func monitorCallback() {
        fetch()
    }
}
