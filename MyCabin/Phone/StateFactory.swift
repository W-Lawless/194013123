//
//  StateFactory.swift
//  MyCabin
//
//  Created by Lawless on 5/5/23.
//

import Combine

final class StateFactory {
    
    let apiClient = GCMSClient()
    var cancelTokens = Set<AnyCancellable>()
    
    //Navigation
    var AppCoordinator: AppCoordinator? = nil
    let rootTabCoordinator = RootTabCoordinator()
    let homeMenuCoordinator = HomeMenuCoordinator()

    let planeViewModel = PlaneViewModel()
    var planeMap  = PlaneMap()
    
    //Views
    let lightsViewModel = LightsViewModel(getLights: getLightsForSeat)
    
    func getLightsForSeat(activeSeat: String) -> [LightModel] {
        let target = self.planeViewModel.plane.allSeats.filter { seat in
            return seat.id == activeSeat
        }

        
        if let seatLights = target.first?.lights {
            return seatLights
        }
        
        return [LightModel]()
    }
    ///Endpoint<EndpointFormats.Get, LightModel>(path: .lights)

    ///Shades
    let shadesViewModel = ShadesViewModel()
    ///Endpoint<EndpointFormats.Get, ShadeModel>(path: .shades)
    
    ///Seats
    let seatsViewModel = SeatsViewModel()
    ///Endpoint<EndpointFormats.Get, SeatModel>(path: .seats)
    
    ///Climate
    let climateViewModel = CabinClimateViewModel()
    ///Endpoint<EndpointFormats.Get, ClimateControllerModel>(path: .climate)
        
    //Media
    let mediaViewModel = MediaViewModel()
        ///Monitors
    let monitorsViewModel = MonitorsViewModel()
    ///Endpoint<EndpointFormats.Get, MonitorModel>(path: .monitors)
        ///Speakers
    let speakersViewModel = SpeakersViewModel()
    ///Endpoint<EndpointFormats.Get, SpeakerModel>(path: .speakers)
        ///Sources
    let sourcesViewModel = SourcesViewModel()
    ///Endpoint<EndpointFormats.Get, SourceModel>(path: .sources)
    
    //Flight
    let flightViewModel = FlightViewModel()
    
    
    
    let flightAPI = RealtimeAPI(endpoint: Endpoint<EndpointFormats.Get, FlightModel>(path: .flightInfo)) { shades in
//        StateFactory.flightViewModel.updateValues(shades)
    }
    
    //Weather
    let weatherViewModel = WeatherViewModel()
    
    
    
    let weatherAPI = RealtimeAPI(endpoint: Endpoint<EndpointFormats.Get, WeatherModel>(path: .weather)) { weather in
//        StateFactory.weatherViewModel.updateValues(weather)
    }
    
}


