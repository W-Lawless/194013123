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
    let monitorsViewModel: MonitorsViewModel //TODO: Refactor to have needed [monitors] at compile not need other obj
    
    init(mediaViewModel: MediaViewModel, monitorsViewModel: MonitorsViewModel) {
        self.mediaViewModel = mediaViewModel
        self.monitorsViewModel = monitorsViewModel
    }
    
    @Published var activeMedia: [UUID:ActiveMedia] = [:]
    @Published var activeMediaID: UUID?
    let selectedActiveMedia = CurrentValueSubject<ActiveMedia, Never>(ActiveMedia())
    let selectedActiveMediaDevice = CurrentValueSubject<MediaDevice, Never>(.monitor)
    
    //TODO: Selected Source?
    //TODO:  IF ACTIVEMEDIA.COUNT > 0 , SET STATE

    
    func assignSourceToSpeaker(speaker: SpeakerModel) {
        mediaViewModel.selectedSpeaker = speaker.id
        
        if let activeMediaID = activeMediaID {
            var mediaGroup = activeMedia[activeMediaID]
            mediaGroup?.speaker = speaker
            activeMedia[activeMediaID] = mediaGroup
            //            let monitor = mediaViewModel.activeMedia[activeMediaID]?.monitor
            //            let source = mediaViewModel.activeMedia[activeMediaID]?.source
            
            //            apiClient.toggleMonitor(monitor!, cmd: true)
            //            apiClient.assignSourceToMonitor(monitor!, source: source!)
            //            apiClient.assignSourceToSpeaker(speaker, source: source!)
            //            apiClient.setVolume(speaker, volume: 50)
        }
        
        mediaViewModel.clearMediaSelection()
        mediaViewModel.mediaViewIntentPublisher.send(.viewNowPlaying)
        mediaViewModel.configureMediaViewIntent()
    }
    
    func assignSourceToMonitor(source: SourceModel) {
        let selectedMonitorModel = monitorsViewModel.monitorsList.first(where: { monitorModel in
            monitorModel.id == mediaViewModel.selectedMonitor
        })
        if let selectedMonitorModel {
            let activeMediaInstance = ActiveMedia(source: source, monitor: selectedMonitorModel)
            activeMedia[activeMediaInstance.id] = activeMediaInstance
            activeMediaID = activeMediaInstance.id
        } else {
            print("monitor not found")
        }
    }
    
}
