//
//  LoadAll.swift
//  MyCabin
//
//  Created by Lawless on 11/29/22.
//

import Foundation

class LoadAllElements {
    
    //Menus
        ///Lights
    static let lightsViewModel = LightsViewModel()
    let lightsAPI = LightsAPI(viewModel: lightsViewModel)
        ///Shades
    static let shadesViewModel = ShadesViewModel()
    let shadesAPI = ShadesAPI(viewModel: shadesViewModel)
        ///Seats
    static let seatsViewModel = SeatsViewModel()
    let seatsAPI = SeatsAPI(viewModel: seatsViewModel)
    
    //Media
        ///Monitors
    static let monitorsViewModel = MonitorsViewModel()
    let monitorsAPI = MonitorsAPI(viewModel: monitorsViewModel)
        ///Speakers
    static let speakersViewModel = SpeakersViewModel()
    let speakersAPI = SpeakersAPI(viewModel: speakersViewModel)
        ///Sources
    static let sourcesViewModel = SourcesViewModel()
    let sourcesAPI = SourcesAPI(viewModel: sourcesViewModel)
    
    //Flight
        ///Flight Info
    static let flightViewModel = FlightViewModel()
    let flightAPI = FlightAPI(viewModel: flightViewModel)
        ///Weather
    static let weatherViewModel = WeatherViewModel()
    let weatherAPI = WeatherApi(viewModel: weatherViewModel)
    
    
    
}
