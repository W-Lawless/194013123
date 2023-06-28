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
    let mediaViewIntentPublisher = CurrentValueSubject<MediaViewIntent, Never>(.selectMonitorOutput)
    
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
    //TODO: - Coalesce into media view model or build out ?
        func configureMediaViewIntent() {
            print("configure media view for",mediaViewIntentPublisher.value)
            switch (mediaViewIntentPublisher.value) {
            case .selectMonitorOutput:
                mediaViewModel.planeDisplayOptions = .showMonitors
                mediaViewModel.mediaDisplayOptions = .outputs
                mediaViewModel.contextualToolTip = MediaToolTips.monitors.rawValue
            case .selectSpeakerOutput:
                mediaViewModel.planeDisplayOptions = .showSpeakers
                mediaViewModel.mediaDisplayOptions = .sound
                mediaViewModel.contextualToolTip = MediaToolTips.speakers.rawValue
            case .viewNowPlaying:
                mediaViewModel.planeDisplayOptions = .showNowPlaying
                mediaViewModel.mediaDisplayOptions = .all
                mediaViewModel.contextualToolTip = MediaToolTips.nowPlaying.rawValue
    
//                activeSpeakerIconCallback = { [weak self] data in
//                    self?.loadActiveMediaControls(data: data, device: .speaker)
//                }
//
//                activeMonitorIconCallback = { [weak self] data in
//                    self?.loadActiveMediaControls(data: data, device: .monitor)
//                }
    
            }
    
        }
    
    
    
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
        print("Selecttting speak")
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
    
    func assignSourceToSpeaker(speaker: SpeakerModel) {
        mediaViewModel.updateSelectedSpeaker(id: speaker.id)

        if let activeMediaID = mediaViewModel.activeMediaID {
            var mediaGroup = mediaViewModel.activeMedia[activeMediaID]
            mediaGroup?.speaker = speaker
            mediaViewModel.activeMedia[activeMediaID] = mediaGroup
//            let monitor = mediaViewModel.activeMedia[activeMediaID]?.monitor
//            let source = mediaViewModel.activeMedia[activeMediaID]?.source
            
//            apiClient.toggleMonitor(monitor!, cmd: true)
//            apiClient.assignSourceToMonitor(monitor!, source: source!)
//            apiClient.assignSourceToSpeaker(speaker, source: source!)
//            apiClient.setVolume(speaker, volume: 50)
        }
        
        mediaViewModel.clearSelection()
        mediaViewIntentPublisher.send(.viewNowPlaying)
        configureMediaViewIntent()
    }
    
    func assignSourceToMonitor(source: SourceModel) {
        let selectedMonitorModel = monitorsViewModel.monitorsList?.first(where: { monitorModel in
            monitorModel.id == mediaViewModel.selectedMonitor
        })
        if let selectedMonitorModel {
            let activeMediaInstance = ActiveMedia(source: source, monitor: selectedMonitorModel)
            mediaViewModel.activeMedia[activeMediaInstance.id] = activeMediaInstance
            mediaViewModel.activeMediaID = activeMediaInstance.id
        } else {
            print("monitor not found")
        }
    }
    
}


