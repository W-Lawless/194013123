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
    let rootTabCoordinator = RootTabCoordinator()
    let homeMenuCoordinator = HomeMenuCoordinator()

    let planeViewModel = PlaneViewModel()
    var planeMap  = PlaneMap()
    
    let mediaViewModel: MediaViewModel
    let lightsViewModel: LightsViewModel
    
    init() {
        self.lightsViewModel = LightsViewModel(plane: planeViewModel)
        self.mediaViewModel = MediaViewModel(apiClient: apiClient)
    }
    
    //Views
    
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
    
    
    //TODO: - API Factory
    let flightAPI = RealtimeAPI(endpoint: Endpoint<EndpointFormats.Get, FlightModel>(path: .flightInfo)) { shades in
//        StateFactory.flightViewModel.updateValues(shades)
    }
    let weatherAPI = RealtimeAPI(endpoint: Endpoint<EndpointFormats.Get, WeatherModel>(path: .weather)) { weather in
        //        StateFactory.weatherViewModel.updateValues(weather)
    }
    
    //Weather
    let weatherViewModel = WeatherViewModel()
    
    
    //MARK: - Media State Update Methods
    
    func selectMonitor(monitor: MonitorModel) {
        let selected = mediaViewModel.selectedMonitor
        if (selected == monitor.id) {
            mediaViewModel.updateSelectedMonitor(id: "")
            mediaViewModel.displaySubView = false
            mediaViewModel.displayToolTip = true
        } else {
            mediaViewModel.updateSelectedMonitor(id: monitor.id)
            mediaViewModel.displaySubView = true
            mediaViewModel.displayToolTip = false
        }
    }
    
    func selectSpeaker(speaker: SpeakerModel) {
        let selected = mediaViewModel.selectedSpeaker
        if (selected == speaker.id) {
            mediaViewModel.updateSelectedSpeaker(id: "")
            mediaViewModel.displaySubView = false
            mediaViewModel.displayToolTip = true
        } else {
            mediaViewModel.updateSelectedSpeaker(id: speaker.id)
            mediaViewModel.displaySubView = true
            mediaViewModel.displayToolTip = false
        }
    }
    
}


