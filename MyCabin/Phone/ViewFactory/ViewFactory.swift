//
//  ViewFactory.swift
//  MyCabin
//
//  Created by Lawless on 6/27/23.
//

import Foundation

final class ViewFactory {
    
    let state: StateFactory
    let plane: PlaneFactory
    
    init(state: StateFactory, plane: PlaneFactory) {
        self.state = state
        self.plane = plane
    }
    
}


extension ViewFactory {
    
    func buildSpeakersView() -> Speakers {
        let view = Speakers(viewModel: self.state.speakersViewModel)
        return view
    }
    
    
    func buildVolumeView() -> Volume {
        let view = Volume(viewModel: self.state.speakersViewModel)
        return view
    }
    
    //Flight
    
    func buildFlightInfo() -> FlightInfo {
        
        let viewModel = state.flightViewModel
        let startMonitor = state.flightAPI.monitor.startMonitor
        let monitorCallback = state.flightAPI.monitorCallback
        let stopMonitor = state.flightAPI.monitor.stopMonitor
        
        let view = FlightInfo(viewModel: viewModel , startMonitor: startMonitor, monitorCallback: monitorCallback, stopMonitor: stopMonitor)
        
        return view
    }
    
    func buildWeatherView() -> Weather {
        
        //        let viewModel = state.weatherViewModel
        //        let startMonitor = state.weatherAPI.monitor.startMonitor
        //        let monitorCallback = state.weatherAPI.monitorCallback
        //        let stopMonitor = state.weatherAPI.monitor.stopMonitor
        
        let view = Weather(viewModel: self.state.weatherViewModel)
        return view
    }
}
