//
//  ViewFactories.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/16/22.
//

import SwiftUI

/// In order to avoid Singeltons, compose all views using dependency injection
/// Unfortunately, this pattern does not seem to work at the root view level, the entry point, so I have
/// had to use a singelton for the CabinAPI class.

struct ViewFactories {
    
    static func buildFlightInfo() -> FlightInfo {
        let viewModel = FlightViewModel()
        let api = FlightAPI(viewModel: viewModel)
        
        let view = FlightInfo(viewModel: viewModel, api: api)
        return view
    }
    
    static func buildSeatsSelection() -> SeatSelection {
        let viewModel = SeatsViewModel()
        let api = SeatsAPI(viewModel: viewModel)
        
        let view = SeatSelection(viewModel: viewModel, api: api)
        return view
    }
    
}
