//
//  ViewFactory.swift
//  MyCabin
//
//  Created by Lawless on 5/5/23.
//

import Foundation
import SwiftUI


final class ViewFactory {
    
    // Coordinators
    static var AppCoordinator: AppCoordinator? = nil
    
    static let homeMenu = UIHostingController(rootView: buildMenuOverview())
    static let volumeMenu = UIHostingController(rootView: buildVolumeView())
    static let loadingView = UIHostingController(rootView: buildLoadingScreen())
    static let mediaTab = UIHostingController(rootView: buildMediaTab())
    static let flightTab = UIHostingController(rootView: buildFlightInfo())
    
    static func buildLoadingScreen() -> Loading {
        let view = Loading()
        return view
    }
    
    static func buildMenuOverview() -> Home {
        let view = Home(navigateTo: NavigationFactory.homeMenuCoordinator.goTo)
        return view
    }
    
    static func buildLightsMenu() -> Lights {
        let view = Lights(planeViewBuilder: PlaneFactory.buildPlaneSchematic, bottomPanelBuilder: buildLightsBottomPanel)
        return view
    }
    
    static func buildLightsBottomPanel() -> LightsBottomPanel {
        let view = LightsBottomPanel(viewModel: StateFactory.lightsViewModel)
        return view
    }
            
    static func buildSeatSelection() -> SeatSelection {
        let view = SeatSelection(viewModel: StateFactory.seatsViewModel, planeViewBuilder: PlaneFactory.buildPlaneSchematic)
        return view
    }
    
    static func buildShadesView() -> Shades {
        let view = Shades(viewModel: StateFactory.shadesViewModel, planeViewBuilder: PlaneFactory.buildPlaneSchematic)
        return view
    }
    
    
    static func buildCabinClimateView() -> CabinClimate {
        let view = CabinClimate(viewModel: StateFactory.climateViewModel, planeViewBuilder: PlaneFactory.buildPlaneSchematic)
        return view
    }
    

    static func buildMediaTab() -> MediaTab {
        let view = MediaTab(mediaViewModel: StateFactory.mediaViewModel, planeViewBuilder: PlaneFactory.buildPlaneSchematic)
        return view
    }
    
    static func buildActiveMediaControlPanel(for item: ActiveMedia, on device: MediaDevice) -> ActiveMediaControlPanel {
        let view = ActiveMediaControlPanel(mediaViewModel: StateFactory.mediaViewModel, activeMedia: item, device: device)
        return view
    }
    
    static func buildMonitorsView() -> Monitors {
        let view = Monitors(viewModel: StateFactory.monitorsViewModel)
        return view
    }
    
    static func buildSourcesView() -> Sources {
        let view = Sources(viewModel: StateFactory.sourcesViewModel)
        return view
    }
    
    static func buildSourceListView(_ filter: SourceTypes = .camera) -> SourceList {
        let view = SourceList(sources: StateFactory.sourcesViewModel, filter: filter)
        return view
    }
    
    static func buildSpeakersView() -> Speakers {
        let view = Speakers(viewModel: StateFactory.speakersViewModel)
        return view
    }
    
    
    static func buildVolumeView() -> Volume {
        let view = Volume(viewModel: StateFactory.speakersViewModel)
        return view
    }
    
    //Flight
    
    static func buildFlightInfo() -> FlightInfo {
        
        let viewModel = StateFactory.flightViewModel
        let startMonitor = StateFactory.flightAPI.monitor.startMonitor
        let monitorCallback = StateFactory.flightAPI.monitorCallback
        let stopMonitor = StateFactory.flightAPI.monitor.stopMonitor
        
        let view = FlightInfo(viewModel: viewModel , startMonitor: startMonitor, monitorCallback: monitorCallback, stopMonitor: stopMonitor)
        
        return view
    }
    
    static func buildWeatherView() -> Weather {
        
//        let viewModel = StateFactory.weatherViewModel
//        let startMonitor = StateFactory.weatherAPI.monitor.startMonitor
//        let monitorCallback = StateFactory.weatherAPI.monitorCallback
//        let stopMonitor = StateFactory.weatherAPI.monitor.stopMonitor
        
        let view = Weather(viewModel: StateFactory.weatherViewModel)
        return view
    }
    
}
