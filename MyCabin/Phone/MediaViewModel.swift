//
//  MediaViewModel.swift
//  MyCabin
//
//  Created by Lawless on 5/6/23.
//

import SwiftUI
import Combine

class MediaViewModel: ObservableObject {

    //MARK: - Properties
    
    let mediaViewIntentPublisher = CurrentValueSubject<MediaViewIntent, Never>(.selectMonitorOutput)

    @Published var planeDisplayOptions: PlaneSchematicDisplayMode = .showMonitors
    @Published var mediaDisplayOptions: MediaDisplayOptions = .outputs
    
    @Published var selectedMonitor: String = ""
    @Published var selectedSpeaker: String = ""
    
    @Published var displaySubView: Bool = false
    @Published var displayToolTip: Bool = true
    @Published var contextualSubView: AnyView = AnyView(Text(""))
    @Published var contextualToolTip: String = MediaToolTips.monitors.rawValue
    
    var sourceList = [SourceModel]()
    var sourceTypes = [SourceType]()
    
    var monitors = [MonitorModel]()
    var speakers = [SpeakerModel]()
    //    var bluetoothDevices

    
    //MARK: - Configuration
    
    func configureMediaViewIntent() {
        
        clearMediaSelection()
        
        switch (mediaViewIntentPublisher.value) {
        case .noActiveMedia:
            placeSettings(.showMonitors, .outputs, .monitors)
        case .selectMonitorOutput:
            placeSettings(.showMonitors, .all, .monitors)
        case .selectSpeakerOutput:
            placeSettings(.showSpeakers, .all, .speakers)
        case .pairSpeakerWithMonitor:
            placeSettings(.showSpeakers, .sound, .speakers)
        case .viewNowPlaying:
            placeSettings(.showNowPlaying, .all, .nowPlaying)
        }
    }
    
    //MARK: - Selection
    
    func selectMonitor(monitor: MonitorModel) {
        let selected = selectedMonitor
        if (isAlreadySelected(selected, monitor.id)) {
            clearSelectedMonitor()
            hideSubView()
        } else {
            selectedMonitor = monitor.id
            showSubView()
        }
    }
    
    func selectSpeaker(speaker: SpeakerModel) {
        let selected = selectedSpeaker
        if (isAlreadySelected(selected, speaker.id)) {
            clearSelectedSpeaker()
            hideSubView()
        } else {
            selectedSpeaker = speaker.id
            showSubView()
        }
    }
    
    //MARK: - Update Methods
    
    func updatePlaneDisplayOptions(_ option: PlaneSchematicDisplayMode) {
        self.planeDisplayOptions = option
    }
    
    func updateSourceList(_ data: [SourceModel]) {
        self.sourceList = data
    }
    
    func updateMonitors(_ data: [MonitorModel]) {
        self.monitors = data
    }
    
    func updateSpeakers(_ data: [SpeakerModel]) {
        self.speakers = data
    }
    
    func updateSourceTypes(_ set: Set<SourceType>) {
        set.forEach { sourceType in
            sourceTypes.append(sourceType)
        }
        sourceTypes.sort { $0.name < $1.name }
    }
    
    func updateContextualToolTip(_ option: PlaneSchematicDisplayMode) {
        switch(option) {
        case .showNowPlaying:
            contextualToolTip = MediaToolTips.nowPlaying.rawValue
        case .showBluetooth:
            contextualToolTip = MediaToolTips.bluetooth.rawValue
        case .showSpeakers:
            contextualToolTip = MediaToolTips.speakers.rawValue
        default:
            contextualToolTip = MediaToolTips.monitors.rawValue
        }
    }
    
    //MARK: - Utils

    func clearMediaSelection() {
        clearSelectedMonitor()
        clearSelectedSpeaker()
        hideSubView()
    }
    
    private func placeSettings(_ planeOptions: PlaneSchematicDisplayMode, _ mediaOptions: MediaDisplayOptions, _ tooltip: MediaToolTips) {
        planeDisplayOptions = planeOptions
        mediaDisplayOptions = mediaOptions
        contextualToolTip = tooltip.rawValue
    }
    
    private func isAlreadySelected(_ prev: String, _ new: String) -> Bool {
        return prev == new
    }
    
    private func clearSelectedMonitor() {
        selectedMonitor = ""
    }

    private func clearSelectedSpeaker() {
        selectedSpeaker = ""
    }
    
    private func hideSubView() {
        displaySubView = false
        displayToolTip = true
    }
    
    private func showSubView() {
        displaySubView = true
        displayToolTip = false
    }
    
}

