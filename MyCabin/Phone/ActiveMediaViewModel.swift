//
//  ActiveMediaViewModel.swift
//  MyCabin
//
//  Created by Lawless on 6/28/23.
//

//TODO: Swap Speaker Output for an Active Monitor
//TODO: Swap Source Input for Speaker/Monitor
//TODO: Speaker with no monitor
//TODO: Swap Monitor Output for an Active Speaker
//TODO: Swap source for monitor already in use from select monitor tab
//TODO: - add bluetooth
//TODO: Monitor with no / mute speaker 
//TODO: Disallow media groups that conflict (same speaker/mon for two dif active media)
//TODO: - what if multiple groups with same source id ? (CONFLICT)

//TODO: Cache Active Media
//TODO:  IF ACTIVEMEDIA.COUNT > 0 , SET STATE
//TODO: STOP button turns off monitors, speakers

import Foundation
import Combine

final class ActiveMediaViewModel: ObservableObject {
    
    
    //MARK: - Properties
    
    
    let apiClient: GCMSClient
    let mediaViewModel: MediaViewModel
    
    init(mediaViewModel: MediaViewModel, apiClient: GCMSClient) {
        self.mediaViewModel = mediaViewModel
        self.apiClient = apiClient
    }
    
    @Published var activeMedia: [UUID:ActiveMedia] = [:]
    @Published var selectedActiveMedia: ActiveMedia? = nil
    @Published var selectedActiveMediaDevice: MediaDevice = MediaDevice.monitor
    var selectedSource: SourceModel = SourceModel()
    
    
    //MARK: - Source Assignment and Selection
    
    
    func selectActiveSource(_ source: SourceModel) {
        self.selectedSource = source
    }
    
    func assignSourceToOutput() {

        guard let selectedActiveMedia = self.activeMedia.first(where: { (key, value) in

            value.source.id == self.selectedSource.id

        }) else {
            
            let activeMediaInstance = createNewActiveMediaGroup(from: selectedSource, withMonitors: mediaViewModel.selectedMonitors, withSpeakers: mediaViewModel.selectedSpeakers)
            self.selectedActiveMedia = activeMediaInstance
            activeMedia[activeMediaInstance.id] = activeMediaInstance
            
            return
        }

        var mediaGroup = activeMedia[selectedActiveMedia.key]
        
        mediaGroup?.monitors = mediaViewModel.selectedMonitors
        mediaGroup?.speakers = mediaViewModel.selectedSpeakers
        
        activeMedia[selectedActiveMedia.key] = mediaGroup
        
        informAPIofNewActieMedia()

    }
    
    
    //MARK: - API Methods
    
    //TODO: Use batch processesing / develop batch processing class
    func informAPIofNewActieMedia() {
        guard let selectedActiveMedia else { return }

        let source = selectedActiveMedia.source
        let monitors = selectedActiveMedia.monitors
        let speakers = selectedActiveMedia.speakers

        monitors.forEach { monitor in
            apiClient.assignSourceToMonitor(monitor, source: source)
            apiClient.toggleMonitor(monitor, cmd: true)
        }

        speakers.forEach { speaker in
            apiClient.assignSourceToSpeaker(speaker, source: source)
            apiClient.setVolume(speaker, volume: 50)
        }
    }
    
    
    //MARK: - Utils
    
    
    func removeActiveMedia(mediaToMakeInactive: ActiveMedia) {
        
        activeMedia.removeValue(forKey: mediaToMakeInactive.id)
        hideActiveMediaControlPanel()
        
        if (activeMedia.isEmpty) {
            mediaViewModel.mediaViewIntentPublisher.send(.noActiveMedia)
            mediaViewModel.configureMediaViewIntent()
        }
    }
        
    func completeOrClearActiveMediaSelection() {
        self.selectedActiveMedia = nil
    }
    
    func hideActiveMediaControlPanel() {
        mediaViewModel.clearMediaSelection()
    }
    
    private func createNewActiveMediaGroup(from source: SourceModel,
                                           withMonitors monitors: [MonitorModel] = [MonitorModel](),
                                           withSpeakers speakers: [SpeakerModel] = [SpeakerModel]()) -> ActiveMedia {
        return ActiveMedia(source: source, monitors: monitors, speakers: speakers)
    }
    
}

