//
//  MediaViewModel.swift
//  MyCabin
//
//  Created by Lawless on 5/6/23.
//

import SwiftUI

protocol MediaModel {}

class MediaViewModel: ObservableObject {
    
    @Published var mediaViewIntent: MediaViewIntent? = nil
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
    
    func changeViewIntent (_ intent: MediaViewIntent) {
        switch (intent) {
        case .selectMonitorOutput:
            planeDisplayOptions = .showMonitors
            mediaDisplayOptions = .outputs
            
            contextualSubView = AnyView(MediaSourceSelection())
            contextualToolTip = MediaToolTips.monitors.rawValue
            
            monitorIconCallback = selectMonitor
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
            
            monitorIconCallback = selectMonitor
            speakerIconCallback = selectSpeaker
            
            contextualToolTip = MediaToolTips.nowPlaying.rawValue
            
            activeSpeakerIconCallback = { [weak self] data in
                self?.loadActiveMediaControls(data: data, device: .speaker)
            }
            
            activeMonitorIconCallback = { [weak self] data in
                self?.loadActiveMediaControls(data: data, device: .monitor)
            }
        }
        
    }

    func selectMonitor(_ monitor: Codable?) {
        if let typecast = monitor as? MonitorModel {
            let selected = StateFactory.mediaViewModel.selectedMonitor
            if (selected == typecast.id) {
                //Clear
                updateSelectedMonitor(id: "")
                displaySubView = false
                displayToolTip = true
            } else {
                updateSelectedMonitor(id: typecast.id)
                displaySubView = true
                displayToolTip = false
            }
        }
    }
    
    func selectSpeaker(_ speaker: Codable?) {
        if let typecast = speaker as? SpeakerModel {
            let selected = StateFactory.mediaViewModel.selectedSpeaker
            if (selected == typecast.id) {
                //Clear
                updateSelectedSpeaker(id: "")
                displaySubView = false
                displayToolTip = true
            } else {
                updateSelectedSpeaker(id: typecast.id)
                displaySubView = true
                displayToolTip = false
            }
        }
    }
    
    func assignSourceToMonitor(source: SourceModel) {
        let selectedMonitorModel = StateFactory.monitorsViewModel.monitorsList?.first(where: { monitorModel in
            monitorModel.id == selectedMonitor
        })
        if let selectedMonitorModel {
            let activeMediaInstance = ActiveMedia(source: source, monitor: selectedMonitorModel)
            activeMedia[activeMediaInstance.id] = activeMediaInstance
            activeMediaID = activeMediaInstance.id
        } else {
            print("monitor not found")
        }
    }
    
    
    func assignSourceToSpeaker(_ speaker: Codable?) {
        let typecast = speaker as? SpeakerModel
        if let typecast {
            
            updateSelectedSpeaker(id: typecast.id)
            
            print("activeMedia", activeMediaID!)
            if let activeMediaID {
                var mediaGroup = activeMedia[activeMediaID]
                mediaGroup?.speaker = typecast
                activeMedia[activeMediaID] = mediaGroup
                let monitor = activeMedia[activeMediaID]?.monitor
                let source = activeMedia[activeMediaID]?.source
                
                StateFactory.apiClient.toggleMonitor(monitor!, cmd: true)
                StateFactory.apiClient.assignSourceToMonitor(monitor!, source: source!)
                
                
                StateFactory.apiClient.assignSourceToSpeaker(typecast, source: source!)
                StateFactory.apiClient.setVolume(typecast, volume: 50)
            }
            
            print("hmm")
            clearSelection()
            changeViewIntent(.viewNowPlaying)

        }
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
        
        contextualSubView = AnyView(ViewFactory.buildActiveMediaControlPanel(for: typecast, on: device))
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
        contextualSubView = AnyView(MediaSourceSelection())
        monitorIconCallback = selectMonitor
        updateContextualToolTip(MediaToolTips.monitors.rawValue)
    }
    
    func clearSelection() {
        self.displayToolTip = true
        self.displaySubView = false
        self.selectedMonitor = ""
        self.selectedSpeaker = ""
    }
    
    
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
