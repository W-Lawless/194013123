//
//  StateFactory.swift
//  MyCabin
//
//  Created by Lawless on 5/5/23.
//


final class StateFactory {
    
    static var apiClient = GCMSClient()
    
    //Views
    static let lightsViewModel = LightsViewModel()
    ///Endpoint<EndpointFormats.Get, LightModel>(path: .lights)

    ///Shades
    static let shadesViewModel = ShadesViewModel()
    ///Endpoint<EndpointFormats.Get, ShadeModel>(path: .shades)
    
    ///Seats
    static let seatsViewModel = SeatsViewModel()
    ///Endpoint<EndpointFormats.Get, SeatModel>(path: .seats)
    
    ///Climate
    static let climateViewModel = CabinClimateViewModel()
    ///Endpoint<EndpointFormats.Get, ClimateControllerModel>(path: .climate)
        
    //Media
    static let mediaViewModel = MediaViewModel()
        ///Monitors
    static let monitorsViewModel = MonitorsViewModel()
    ///Endpoint<EndpointFormats.Get, MonitorModel>(path: .monitors)
        ///Speakers
    static let speakersViewModel = SpeakersViewModel()
    ///Endpoint<EndpointFormats.Get, SpeakerModel>(path: .speakers)
        ///Sources
    static let sourcesViewModel = SourcesViewModel()
    ///Endpoint<EndpointFormats.Get, SourceModel>(path: .sources)
    
    //Flight
    static let flightViewModel = FlightViewModel()
    
    static var flightEndpoint = Endpoint<EndpointFormats.Get, FlightModel>(path: .flightInfo)
    
    static let flightAPI = RealtimeAPI(endpoint: flightEndpoint) { shades in
        StateFactory.flightViewModel.updateValues(shades)
    }
    
    //Weather
    static let weatherViewModel = WeatherViewModel()
    
    static var weatherEndpoint = Endpoint<EndpointFormats.Get, WeatherModel>(path: .weather)
    
    static let weatherAPI = RealtimeAPI(endpoint: weatherEndpoint) { weather in
        StateFactory.weatherViewModel.updateValues(weather)
    }
    
}
