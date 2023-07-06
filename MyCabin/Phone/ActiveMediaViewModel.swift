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
    var selectedSource: SourceModel = SourceModel()
    
    //TODO: Swap Speaker Output for Monitor
    //TODO: Swap Source Input for Speaker/Monitor
    //TODO: Swap Monitor Output for Speaker
    //TODO: Speaker to Monitor or    
    
    //TODO: Cache Active Media
    //TODO:  IF ACTIVEMEDIA.COUNT > 0 , SET STATE
    
    func assignSourceToSpeakers() {
//        if(selectedActiveMedia.source.id == "") {
//            if let source {
//                let activeMediaInstance = ActiveMedia(source: source, speakers: mediaViewModel.selectedSpeakers)
//                selectedActiveMedia = activeMediaInstance
//                activeMedia[activeMediaInstance.id] = activeMediaInstance
//            }
//        } else {
        print("Currently working with",selectedActiveMedia.id)
            var mediaGroup = activeMedia[selectedActiveMedia.id]
            mediaGroup?.speakers = mediaViewModel.selectedSpeakers
            activeMedia[selectedActiveMedia.id] = mediaGroup
//        }
        
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
    
    func assignSourceToMonitors() {
        let activeMediaInstance = ActiveMedia(source: selectedSource, monitors: mediaViewModel.selectedMonitors)
        selectedActiveMedia = activeMediaInstance
        activeMedia[activeMediaInstance.id] = activeMediaInstance
    }
    
    func selectActiveSource(_ source: SourceModel) {
        self.selectedSource = source
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
