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
    
    @Published var planeDisplayOptions: PlaneSchematicDisplayMode = .showMonitors
    @Published var mediaDisplayOptions: MediaDisplayOptions = .outputs

    @Published var selectedMonitor: String = ""
    @Published var selectedSpeaker: String = ""
    @Published var selectedSource: SourceModel?

    @Published var activeMedia: [UUID:ActiveMedia] = [:]
    @Published var activeMediaID: UUID?
    @Published var selectedActiveMedia: UUID?
    @Published var controlPanelDisplayingFor: MediaDevice?
    
//    @Published var speakerIconCallback: (_: Codable?) -> () = { _ in }
//    @Published var monitorIconCallback: (_: Codable?) -> () = { _ in }
    @Published var activeSpeakerIconCallback: (_: Codable?) -> () = { _ in }
    @Published var activeMonitorIconCallback: (_: Codable?) -> () = { _ in }
    
    @Published var displaySubView: Bool = false
    @Published var displayToolTip: Bool = true
    @Published var contextualSubView: AnyView = AnyView(Text(""))
    @Published var contextualToolTip: String = MediaToolTips.monitors.rawValue
    
    
    //TODO: - Refactor this nightmare
    //  IF ACTIVEMEDIA.COUNT > 0 , SET STATE


    

    
    

    
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

