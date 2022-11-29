//
//  ViewFactories.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/16/22.
//

import SwiftUI

struct XViewFactories {
    
    static let speakersViewModel = SpeakersViewModel()
    
    static func buildFlightInfo() -> FlightInfo {
        let viewModel = FlightViewModel()
        let api = FlightAPI(viewModel: viewModel)
        
        let view = FlightInfo(viewModel: viewModel, api: api)
        return view
    }
    
    static func buildSeatSelection() -> SeatSelection {
        let viewModel = SeatsViewModel()
        let api = SeatsAPI(viewModel: viewModel)
        
        let view = SeatSelection(viewModel: viewModel, api: api)
        return view
    }
    
    static func buildWeatherView() -> Weather {
        let viewModel = WeatherViewModel()
        let api = WeatherApi(viewModel: viewModel)
        
        let view = Weather(viewModel: viewModel, api: api)
        return view
    }
    
    static func buildShadesView() -> Shades {
        let viewModel = ShadesViewModel()
        let api = ShadesAPI(viewModel: viewModel)
        
        let view = Shades(viewModel: viewModel, api: api)
        return view
    }
    
    static func buildLightsView() -> Lights {
        let viewModel = LightsViewModel()
        let api = LightsAPI(viewModel: viewModel)
        
        let view = Lights(viewModel: viewModel, api: api)
        return view
    }
    
    static func buildMonitorsView() -> Monitors {
        let viewModel = MonitorsViewModel()
        let api = MonitorsAPI(viewModel: viewModel)
        
        let view = Monitors(viewModel: viewModel, api: api)
        return view
    }
    
    static func buildSourcesView() -> Sources {
        let viewModel = SourcesViewModel()
        let api = SourcesAPI(viewModel: viewModel)
        
        let view = Sources(viewModel: viewModel, api: api)
        return view
    }
    
    static func buildSpeakersView() -> Speakers {
        let api = SpeakersAPI(viewModel: self.speakersViewModel)
        
        let view = Speakers(viewModel: self.speakersViewModel, api: api)
        return view
    }
    
    static func buildVolumeView() -> Volume {
        let api = SpeakersAPI(viewModel: self.speakersViewModel)
        
        let view = Volume(viewModel: self.speakersViewModel, api: api)
        return view
    }
    
}
