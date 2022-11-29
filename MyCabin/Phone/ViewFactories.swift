//
//  LoadAll.swift
//  MyCabin
//
//  Created by Lawless on 11/29/22.
//

import Foundation

final class ViewFactories {
    
    //MARK: - Properties
    
    //Menus
        ///Lights
    static let lightsViewModel = LightsViewModel()
    static let lightsAPI = LightsAPI(viewModel: lightsViewModel)
        ///Shades
    static let shadesViewModel = ShadesViewModel()
    static let shadesAPI = ShadesAPI(viewModel: shadesViewModel)
        ///Seats
    static let seatsViewModel = SeatsViewModel()
    static let seatsAPI = SeatsAPI(viewModel: seatsViewModel)
    
    //Media
        ///Monitors
    static let monitorsViewModel = MonitorsViewModel()
    static let monitorsAPI = MonitorsAPI(viewModel: monitorsViewModel)
        ///Speakers
    static let speakersViewModel = SpeakersViewModel()
    static let speakersAPI = SpeakersAPI(viewModel: speakersViewModel)
        ///Sources
    static let sourcesViewModel = SourcesViewModel()
    static let sourcesAPI = SourcesAPI(viewModel: sourcesViewModel)
    
    //Flight
        ///Flight Info
    static let flightViewModel = FlightViewModel()
    static let flightAPI = FlightAPI(viewModel: flightViewModel)
        ///Weather
    static let weatherViewModel = WeatherViewModel()
    static let weatherAPI = WeatherApi(viewModel: weatherViewModel)
    
    //MARK: - View Builders
    
    static func buildFlightInfo() -> FlightInfo {
        let view = FlightInfo(viewModel: flightViewModel, api: flightAPI)
        return view
    }
    
    static func buildSeatSelection() -> SeatSelection {
        let view = SeatSelection(viewModel: seatsViewModel, api: seatsAPI)
        return view
    }
    
    static func buildWeatherView() -> Weather {
        let view = Weather(viewModel: weatherViewModel, api: weatherAPI)
        return view
    }
    
    static func buildShadesView() -> Shades {
        let view = Shades(viewModel: shadesViewModel, api: shadesAPI)
        return view
    }
    
    static func buildLightsView() -> Lights {
        let view = Lights(viewModel: lightsViewModel, api: lightsAPI)
        return view
    }
    
    static func buildMonitorsView() -> Monitors {
        let view = Monitors(viewModel: monitorsViewModel, api: monitorsAPI)
        return view
    }
    
    static func buildSourcesView() -> Sources {
        let view = Sources(viewModel: sourcesViewModel, api: sourcesAPI)
        return view
    }
    
    static func buildSpeakersView() -> Speakers {
        let view = Speakers(viewModel: speakersViewModel, api: speakersAPI)
        return view
    }
    
    static func buildVolumeView() -> Volume {
        let view = Volume(viewModel: speakersViewModel, api: speakersAPI)
        return view
    }
    
    
    //MARK: - Fetch Methods
    ///TODO: ASYNCSEQUENCE / ASYNCSTREAM
    
    static func fetchAll() {
        lightsAPI.fetch()
        shadesAPI.fetch()
        seatsAPI.getSeats() ///TODO

        monitorsAPI.fetch()
        speakersAPI.fetch()
        sourcesAPI.fetch()
        
        flightAPI.fetch()
        weatherAPI.fetch()
    }
    
}
