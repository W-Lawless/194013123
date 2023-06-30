//
//  ActiveMediaViewModel.swift
//  MyCabin
//
//  Created by Lawless on 6/28/23.
//

import Foundation
import Combine

final class ActiveMediaViewModel: ObservableObject {
    
    let mediaViewModel: MediaViewModel
    
    init(mediaViewModel: MediaViewModel) {
        self.mediaViewModel = mediaViewModel
    }
    
    @Published var activeMedia: [UUID:ActiveMedia] = [:]
    @Published var selectedActiveMedia: ActiveMedia = ActiveMedia()
    @Published var selectedActiveMediaDevice: MediaDevice = MediaDevice.monitor
    
    //TODO: Swap Speaker Output for Monitor
    //TODO: Swap Source Input for Speaker/Monitor
    //TODO: Swap Monitor Output for Speaker
    //TODO: Speaker to Monitor or
    //TODO: MultiSpeaker
    //TODO: MultiMonitor
    
    
    //TODO: Cache Active Media
    //TODO:  IF ACTIVEMEDIA.COUNT > 0 , SET STATE
    
    func assignSourceToSpeaker(speaker: SpeakerModel) {
        
        mediaViewModel.selectedSpeaker = speaker.id
                
        var mediaGroup = activeMedia[selectedActiveMedia.id]
        mediaGroup?.speaker = speaker
        activeMedia[selectedActiveMedia.id] = mediaGroup
//        TODO: --
//        let monitor = mediaViewModel.activeMedia[activeMediaID]?.monitor
//        let source = mediaViewModel.activeMedia[activeMediaID]?.source
//
//        apiClient.toggleMonitor(monitor!, cmd: true)
//        apiClient.assignSourceToMonitor(monitor!, source: source!)
//        apiClient.assignSourceToSpeaker(speaker, source: source!)
//        apiClient.setVolume(speaker, volume: 50)
//
    }
    
    func assignSourceToMonitor(source: SourceModel) {
        guard let selectedMonitorModel = mediaViewModel.monitors.first(where: { monitorModel in
            monitorModel.id == mediaViewModel.selectedMonitor
        }) else { return }
        
        let activeMediaInstance = ActiveMedia(source: source, monitor: selectedMonitorModel)
        selectedActiveMedia = activeMediaInstance
        activeMedia[activeMediaInstance.id] = activeMediaInstance        
    }
    
    func completeOrClearActiveMediaSelection() {
        selectedActiveMedia = ActiveMedia()
    }
    
    func hideActiveMediaControlPanel() {
        mediaViewModel.clearMediaSelection()
    }
    
    func removeActiveMedia(mediaToMakeInactive: ActiveMedia) {
        
        activeMedia.removeValue(forKey: mediaToMakeInactive.id)
        hideActiveMediaControlPanel()
        
        if (activeMedia.isEmpty) {
            mediaViewModel.mediaViewIntentPublisher.send(.noActiveMedia)
            mediaViewModel.configureMediaViewIntent()
            mediaViewModel.clearMediaSelection()
        }
    }
    
}
