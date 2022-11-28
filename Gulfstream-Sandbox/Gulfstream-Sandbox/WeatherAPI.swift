//
//  +WeatherAPI.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/22/22.
//

import Foundation
import Combine

class WeatherApi {
    
    let viewModel: WeatherViewModel
    let monitor = HeartBeatMonitor()
    var cancelToken: Cancellable?
    
    private let endpoint = Endpoint<EndpointFormats.Get, WeatherModel>(path: "/api/v1/destination/weather")
    
    init(viewModel: WeatherViewModel) {
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
                    return
                }
            },
            receiveValue: { weather in
                self.viewModel.updateValues(true, weather[0])
            }
        )
    }
    
    func monitorCallback() {
        fetch()
    }
    
}


