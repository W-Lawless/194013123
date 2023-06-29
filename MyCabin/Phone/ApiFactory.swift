//
//  ApiFactory.swift
//  MyCabin
//
//  Created by Lawless on 6/27/23.
//

import Combine

final class APIFactory {
    
    let apiClient = GCMSClient()
    var cancelTokens = Set<AnyCancellable>()

    let cabinAPI: CabinAPI<EndpointFormats.Head, EmptyResponse>
    let cabinConnectionPublisher = CurrentValueSubject<Bool, Never>(false)
    
    init() {
        let cabinEndpoint = Endpoint<EndpointFormats.Head, EmptyResponse>(path: .ping)
        self.cabinAPI = CabinAPI(endpoint: cabinEndpoint, publisher: cabinConnectionPublisher) { _ in }
        
//        self.flightAPI = buildRealTimeAPI(endpoint: Endpoint<EndpointFormats.Get, FlightModel>(path: .flightInfo), viewModel: flightViewModel)
//        self.weatherAPI = buildRealTimeAPI(endpoint: Endpoint<EndpointFormats.Get, WeatherModel>(path: .weather), viewModel: weatherViewModel)
        
    }
    
    func buildRealTimeAPI<F, R>(endpoint: Endpoint<F, R>, viewModel: GCMSViewModel) -> RealtimeAPI<F, R> {
        let rtApi = RealtimeAPI(endpoint: endpoint) { result in
            viewModel.updateValues(result)
        }
        return rtApi
    }
    
}


//TODO: - API Factory
//TODO: - Bluetooth api that real time watches for new devices
//    let flightAPI: RealtimeAPI<EndpointFormats.Get, FlightModel>
//    let weatherAPI: RealtimeAPI<EndpointFormats.Get, WeatherModel>
