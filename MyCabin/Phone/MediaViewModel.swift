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
    
    @Published var selectedMonitors = [MonitorModel]()
    @Published var selectedSpeakers = [SpeakerModel]()
    
    @Published var displaySubView: Bool = false
    @Published var displayToolTip: Bool = true
    @Published var contextualToolTip: String = MediaToolTips.monitors.rawValue
    
    var sourceList = [SourceModel]()
    var sourceTypes = [SourceType]()
    
    var monitors = [MonitorModel]()
    var speakers = [SpeakerModel]()
    //    var bluetoothDevices

    
    //MARK: - Configuration
    
    func configureMediaViewIntent() {
        
        switch (mediaViewIntentPublisher.value) {
            
        case .noActiveMedia:
            
            clearMediaSelection()
            placeSettings(.showMonitors, .outputs, .monitors)
            
        case .selectMonitorOutput:
            
            clearMediaSelection()
            placeSettings(.showMonitors, .all, .monitors)
            
        case .selectSpeakerOutput:
            
            clearMediaSelection()
            placeSettings(.showSpeakers, .all, .speakers)
            
        case .pairSpeakerWithMonitor:
            
            hideSubView()
            placeSettings(.showSpeakers, .sound, .speakers)
            
        case .pairMonitorWithSpeaker:
            
            hideSubView()
            placeSettings(.showMonitors, .onlyVisible, .monitors)
            
        case .viewNowPlaying:
            
            clearMediaSelection()
            placeSettings(.showNowPlaying, .all, .nowPlaying)
            
        }
    }
    
    //MARK: - Selection
    
    func selectMonitor(monitor: MonitorModel) {
        let selected = selectedMonitors.contains(monitor)
        if (selected) {
            deselectMonitor(monitor)
            if(selectedMonitors.count == 0) {
                hideSubView()
            }
        } else {
            selectedMonitors.append(monitor)
            showSubView()
        }
    }
    
    func selectSpeaker(speaker: SpeakerModel) {
        let selected = selectedSpeakers.contains(speaker)
        if (selected) {
            deselectSpeaker(speaker)
            if(selectedSpeakers.count == 0) {
                hideSubView()
            }
        } else {
            selectedSpeakers.append(speaker)
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
    
    func updateSpeakerState(for speaker: SpeakerModel) {
        self.speakers.mapInPlace({ value in
            if(value.id == speaker.id) {
                value = speaker
            }
        })
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
    
    private func placeSettings(_ planeOptions: PlaneSchematicDisplayMode, _ mediaOptions: MediaDisplayOptions, _ tooltip: MediaToolTips) {
        planeDisplayOptions = planeOptions
        mediaDisplayOptions = mediaOptions
        contextualToolTip = tooltip.rawValue
    }

    func clearMediaSelection() {
        clearAllSelectedMonitors()
        clearAllSelectedSpeakers()
        hideSubView()
    }
    
    private func deselectMonitor(_ monitor: MonitorModel) {
        selectedMonitors.removeAll { existing in
            existing.id == monitor.id
        }
    }
    
    private func clearAllSelectedMonitors() {
        selectedMonitors = [MonitorModel]()
    }

    private func deselectSpeaker(_ speaker: SpeakerModel) {
        selectedSpeakers.removeAll { existing in
            existing.id == speaker.id
        }
    }
    
    private func clearAllSelectedSpeakers() {
        selectedSpeakers = [SpeakerModel]()
    }
    
    func hideSubView() {
        displaySubView = false
        displayToolTip = true
    }
    
    func showSubView() {
        displaySubView = true
        displayToolTip = false
    }
    
}

