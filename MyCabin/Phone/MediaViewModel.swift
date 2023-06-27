//
//  MediaViewModel.swift
//  MyCabin
//
//  Created by Lawless on 5/6/23.
//

import SwiftUI

protocol MediaModel {}

class MediaViewModel: ObservableObject {
    
    let apiClient: GCMSClient
    
    init(apiClient: GCMSClient) {
        self.apiClient = apiClient
    }
    
    @Published var mediaViewIntent: MediaViewIntent = .selectMonitorOutput
    @Published var planeDisplayOptions: PlaneSchematicDisplayMode = .showMonitors
    @Published var mediaDisplayOptions: MediaDisplayOptions = .outputs

    @Published var selectedMonitor: String = ""
    @Published var selectedSpeaker: String = ""
    @Published var selectedSource: SourceModel?

    @Published var activeMedia: [UUID:ActiveMedia] = [:]
    @Published var activeMediaID: UUID?
    @Published var selectedActiveMedia: UUID?
    @Published var controlPanelDisplayingFor: MediaDevice?
    
    @Published var speakerIconCallback: (_: Codable?) -> () = { _ in }
    @Published var monitorIconCallback: (_: Codable?) -> () = { _ in }
    @Published var activeSpeakerIconCallback: (_: Codable?) -> () = { _ in }
    @Published var activeMonitorIconCallback: (_: Codable?) -> () = { _ in }
    
    @Published var displaySubView: Bool = false
    @Published var displayToolTip: Bool = true
    @Published var contextualSubView: AnyView = AnyView(Text(""))
    @Published var contextualToolTip: String = ""
    
    
    //TODO: - Refactor this nightmare
    //  IF ACTIVEMEDIA.COUNT > 0 , SET STATE
    func changeViewIntent (_ intent: MediaViewIntent) {
        switch (intent) {
        case .selectMonitorOutput:
            planeDisplayOptions = .showMonitors
            mediaDisplayOptions = .outputs
            
//            contextualSubView = AnyView(MediaSourceSelection())
            contextualToolTip = MediaToolTips.monitors.rawValue
            
            //TODO: View Fac changes callback on intent
            speakerIconCallback = { _ in }
                        
        case .selectSpeakerOutput:
            
            planeDisplayOptions = .showSpeakers
            mediaDisplayOptions = .sound
            
            contextualToolTip = MediaToolTips.speakers.rawValue
            
            speakerIconCallback = assignSourceToSpeaker
            monitorIconCallback = { _ in }
            
            
        case .viewNowPlaying:
            planeDisplayOptions = .showNowPlaying
            mediaDisplayOptions = .all
            
//            speakerIconCallback = selectSpeaker
            
            contextualToolTip = MediaToolTips.nowPlaying.rawValue
            
            activeSpeakerIconCallback = { [weak self] data in
                self?.loadActiveMediaControls(data: data, device: .speaker)
            }
            
            activeMonitorIconCallback = { [weak self] data in
                self?.loadActiveMediaControls(data: data, device: .monitor)
            }
            
        }
        
    }

    
    func assignSourceToMonitor(source: SourceModel) {
        //TODO: -
//        let selectedMonitorModel = StateFactory.monitorsViewModel.monitorsList?.first(where: { monitorModel in
//            monitorModel.id == selectedMonitor
//        })
//        if let selectedMonitorModel {
//            let activeMediaInstance = ActiveMedia(source: source, monitor: selectedMonitorModel)
//            activeMedia[activeMediaInstance.id] = activeMediaInstance
//            activeMediaID = activeMediaInstance.id
//        } else {
//            print("monitor not found")
//        }
    }
    
    
    func assignSourceToSpeaker(_ speaker: Codable?) {
        let speaker = speaker as! SpeakerModel
        updateSelectedSpeaker(id: speaker.id)
        
        print("activeMedia", activeMediaID!)
        if let activeMediaID {
            var mediaGroup = activeMedia[activeMediaID]
            mediaGroup?.speaker = speaker
            activeMedia[activeMediaID] = mediaGroup
            let monitor = activeMedia[activeMediaID]?.monitor
            let source = activeMedia[activeMediaID]?.source
            
            apiClient.toggleMonitor(monitor!, cmd: true)
            apiClient.assignSourceToMonitor(monitor!, source: source!)
            
            
            apiClient.assignSourceToSpeaker(speaker, source: source!)
            apiClient.setVolume(speaker, volume: 50)
        }
        
        print("hmm")
        clearSelection()
        changeViewIntent(.viewNowPlaying)

        
    }
    
    func loadActiveMediaControls(data: Codable?, device: MediaDevice){
        guard let data else { return }
        guard let typecast = data as? ActiveMedia else { return }
        self.selectedActiveMedia = typecast.id

        self.displaySubView.toggle()
        self.displayToolTip.toggle()
        
        if(self.controlPanelDisplayingFor != device) {
            self.displaySubView = true
            self.displayToolTip = false
        }
        
//        contextualSubView = AnyView(ViewFactory.buildActiveMediaControlPanel(for: typecast, on: device))
        controlPanelDisplayingFor = device
    }


    func updatePlaneDisplayOptions(_ options: PlaneSchematicDisplayMode) {
        self.planeDisplayOptions = options
    }
    
    func updateContextualToolTip(_ text: String) {
        self.contextualToolTip = text
    }
    
    func updateSelectedSource(source: SourceModel) {
        self.selectedSource = source
    }
    
    func updateSelectedMonitor(id monitorID: String) {
        self.selectedMonitor = monitorID
    }
    
    
    func updateSelectedSpeaker(id speakerID: String) {
        self.selectedSpeaker = speakerID
    }
    
    
    func configForSelectMonitor() {
//        contextualSubView = AnyView(MediaSourceSelection())
//        monitorIconCallback = selectMonitor
        updateContextualToolTip(MediaToolTips.monitors.rawValue)
    }
    
    func clearSelection() {
        self.displayToolTip = true
        self.displaySubView = false
        self.selectedMonitor = ""
        self.selectedSpeaker = ""
    }
    
    
}


//TODO: +

enum MediaDisplayOptions {
    case all
    case outputs
    case sound
}

enum MediaDevice: String {
    case monitor
    case speaker
    case bluetooth
}

enum MediaViewIntent {
    case selectMonitorOutput
    case selectSpeakerOutput
    case viewNowPlaying
}

enum MediaToolTips: String {
    case monitors = "Select a monitor output:"
    case speakers = "Select a speaker output:"
    case bluetooth = "Select a bluetooth device:"
    case nowPlaying = "Currently playing media:"
}

struct ActiveMedia: Equatable, Hashable, Codable {
    var id = UUID()
    var source: SourceModel
    var monitor: MonitorModel?
    var speaker: SpeakerModel?
    var bluetooth: String?
    
    static func == (lhs: ActiveMedia, rhs: ActiveMedia) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}
