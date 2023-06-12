//
//  MediaFactory.swift
//  MyCabin
//
//  Created by Lawless on 5/5/23.
//

import Foundation
import Combine

final class MediaFactory {

//    static let dynamicOptions = CurrentValueSubject<PlaneSchematicDisplayMode, Never>(.showMonitors)

//    static func monitorIconCallback(monitor: MonitorModel) {
//        let selected = StateFactory.mediaViewModel.selectedMonitor
//        if (selected == monitor.id) {
//            //Clear
//            StateFactory.mediaViewModel.updateSelectedMonitor(id: "")
//        } else {
//            StateFactory.mediaViewModel.updateSelectedMonitor(id: monitor.id)
//        }
//    }
//
//    static func speakerIconCallback(speaker: SpeakerModel) {
//        print("selected", speaker.id)
//        //        StateFactory.monitorsViewModel.selectedMonitor = monitor
//        let selected = UserDefaults.standard.string(forKey: "SelectedSpeaker")
//        if (selected == speaker.id) {
//            UserDefaults.standard.set("", forKey: "SelectedSpeaker")
//        } else {
//            UserDefaults.standard.set(speaker.id, forKey: "SelectedSpeaker")
//        }
  
//        StateFactory.mediaViewModel.updateMediaDisplay(.all)
//        let newNavStack = ViewFactory.buildNowPlayingMediaTab()
//        NavigationFactory.mediaCoordinator.start(subviews: [newNavStack])
//        NavigationFactory.mediaCoordinator.dismiss()

    
//    static func assignSourceToMonitor(source: SourceModel) {
//        let selectedMonitorID = UserDefaults.standard.string(forKey: "SelectedMonitor")
//        let selectedMonitor = StateFactory.monitorsViewModel.monitorsList?.first(where: { monitorModel in
//            monitorModel.id == selectedMonitorID
//        })
//        if let selectedMonitor {
//            StateFactory.monitorsViewModel.updatePlayingMonitors(monitor: selectedMonitor, source: source)
//        } else {
//            print("monitor not found")
//        }
//    }
    
}
