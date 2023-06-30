//
//  ViewFactory+Media.swift
//  MyCabin
//
//  Created by Lawless on 6/27/23.
//

import SwiftUI

extension ViewFactory {
    
    func buildMediaTab() -> MediaTab {
        let view = MediaTab(mediaViewModel: state.mediaViewModel,
                            activeMediaViewModel: state.activeMediaViewModel,
                            planeViewBuilder: buildPlaneSchematic,
                            mediaSubViewBuilder: buildMediaSubView)
        return view
    }
    
}

//MARK: - Options Bar

extension ViewFactory {
    
    func buildMediaDiplayOptionsBar() -> MediaOptions {
        let view = MediaOptions(mediaOptionsButtonBuilder: buildMediaDisplayOptionButton)
        return view
    }
    
    func buildMediaDisplayOptionButton(image: String, option: PlaneSchematicDisplayMode) -> MediaOptionsButton {
        let view = MediaOptionsButton(imageName: image, planeDisplayOptions: option)
        return view
    }
    
}


//MARK: - Monitors


extension ViewFactory {
    
    func buildMonitorsBlueprint(area: PlaneArea) -> MonitorsBlueprint {
        let view = MonitorsBlueprint(areaMonitors: area.monitors ?? [MonitorModel](), monitorButtonBuilder: buildMonitorButton)
        return view
    }
    
    func buildMonitorButton(monitor: MonitorModel, selected: Bool) -> MonitorButton {
        let view = MonitorButton(monitor: monitor, selected: selected) { monitor in
            switch(self.state.mediaViewModel.mediaViewIntentPublisher.value) {
            case .selectSpeakerOutput:
                print("ayyy")
            default:
                print("Monitor Button built in Default Context")
                self.state.mediaViewModel.selectMonitor(monitor: monitor)
            }
        }
        return view
    }
    
}
   

//MARK: - Speakers


extension ViewFactory {
    
    func buildSpeakerBlueprint(area: PlaneArea) -> SpeakersBlueprint {
        let view = SpeakersBlueprint(areaSpeakers: area.speakers ?? [SpeakerModel](), speakerButtonBuilder: buildSpeakerButton)
        return view
    }
    
    func buildSpeakerButton(speaker: SpeakerModel, selected: Bool) -> SpeakerButton {
        let view = SpeakerButton(speaker: speaker, selected: selected) { speaker in
            switch(self.state.mediaViewModel.mediaViewIntentPublisher.value) {
            case .pairSpeakerWithMonitor:
                self.state.activeMediaViewModel.assignSourceToSpeaker(speaker: speaker)
                self.state.activeMediaViewModel.completeOrClearActiveMediaSelection()
                self.state.mediaViewModel.mediaViewIntentPublisher.send(.viewNowPlaying)
                self.state.mediaViewModel.configureMediaViewIntent()
            default:
                self.state.mediaViewModel.selectSpeaker(speaker: speaker)
            }
        }
        
        return view
    }
}


//MARK: - NowPlaying ActiveMedia


extension ViewFactory {
    
    func buildNowPlayingBluePrint(area: PlaneArea) -> NowPlayingBlueprint {
        let view = NowPlayingBlueprint(area: area, activeMediaButtonGroupBuilder: buildActiveMediaButtonGroup)
        return view
    }
    
    func buildActiveMediaButtonGroup(area: PlaneArea, activeMedia: ActiveMedia) -> ActiveMediaButtonGroup {
        var speakersInArea = [SpeakerModel]()
        var monitorsInArea = [MonitorModel]()
        //var bluetoothDevicesInArea: [BluetoothDevice]
    //TODO: - Bluetooth
        
        if let speaker = activeMedia.speaker {
            if(speakerInArea(area: area, speaker: speaker)) {
                speakersInArea.append(speaker)
            }
        }
        if let monitor = activeMedia.monitor {
            if(monitorInArea(area: area, monitor: monitor)) {
                monitorsInArea.append(monitor)
            }
        }
        
        let view = ActiveMediaButtonGroup(activeMedia: activeMedia, speakers: speakersInArea, monitors: monitorsInArea, activeMediaDeviceButtonBuilder: buildActiveMediaDeviceButton)
        return view
    }
    
    func buildActiveMediaDeviceButton(activeMedia: ActiveMedia, deviceModel: MediaDeviceModel, device: MediaDevice) -> ActiveMediaDeviceButton {
        
        let view = ActiveMediaDeviceButton(activeMedia: activeMedia, deviceModel: deviceModel, device: device) {
            
            if(self.activeMediaNotAlreadySelected(activeMedia.id)) {
                
                self.state.activeMediaViewModel.selectedActiveMedia = activeMedia
                self.state.activeMediaViewModel.selectedActiveMediaDevice = device
                self.updateActiveMediaControlPanel(activeMedia: activeMedia, device: device)
                
            } else if(self.activeMediaIsAlreadySelected(activeMedia.id) && self.differentOutputSelected(device)) {
                
                self.state.activeMediaViewModel.selectedActiveMediaDevice = device
                self.updateActiveMediaControlPanel(activeMedia: activeMedia, device: device)
                
            } else if (self.activeMediaIsAlreadySelected(activeMedia.id) && self.sameOutputSelected(device)) {
                
                self.state.activeMediaViewModel.completeOrClearActiveMediaSelection()
                self.state.mediaViewModel.hideSubView()
                
            }
            
        }
        
        return view
        
    }
    
    private func speakerInArea(area: PlaneArea, speaker: SpeakerModel) -> Bool {
        guard let areaSpeakers = area.speakers  else { return false }

        let allSpeakerIDs = areaSpeakers.map {
            $0.id
        }
            
        if ( allSpeakerIDs.contains(speaker.id) ) {
            return true
        } else {
            return false
        }
    }
    
    private func monitorInArea(area: PlaneArea, monitor: MonitorModel) -> Bool {
        guard let areaMonitors = area.monitors  else { return false }
        
        let allMonitorIDs = areaMonitors.map {
            $0.id
        }
        
        if ( allMonitorIDs.contains(monitor.id) ) {
            return true
        } else {
            return false
        }
    }
    
    private func activeMediaNotAlreadySelected(_ id: UUID) -> Bool {
        return self.state.activeMediaViewModel.selectedActiveMedia.id != id
    }
    
    private func activeMediaIsAlreadySelected(_ id: UUID) -> Bool {
        return self.state.activeMediaViewModel.selectedActiveMedia.id == id
    }
    
    private func differentOutputSelected(_ device: MediaDevice) -> Bool {
        return self.state.activeMediaViewModel.selectedActiveMediaDevice != device
    }
    
    private func sameOutputSelected(_ device: MediaDevice) -> Bool {
        return self.state.activeMediaViewModel.selectedActiveMediaDevice == device
    }
    
}

//MARK: - Subview Builder


extension ViewFactory {
    
    func buildMediaSubView() -> AnyView {
        switch (self.state.mediaViewModel.mediaViewIntentPublisher.value) {
        case .viewNowPlaying:
            switch(self.state.mediaViewModel.planeDisplayOptions) {
            case .showNowPlaying:
                return AnyView(
                    self.buildActiveMediaControlPanel(for: self.state.activeMediaViewModel.selectedActiveMedia,
                                                      on: self.state.activeMediaViewModel.selectedActiveMediaDevice))
            default:
                return AnyView(buildMediaSourceSelection())
            }
        default:
            return AnyView(buildMediaSourceSelection())
        }
    }
    
}
    
//MARK: - Active Media Control Panel

extension ViewFactory {
    
    func buildActiveMediaControlPanel(for activeMedia: ActiveMedia, on device: MediaDevice) -> ActiveMediaControlPanel {
        let view = ActiveMediaControlPanel(activeMediaViewModel: state.activeMediaViewModel, activeMedia: activeMedia, device: device) {
            let destination = UIHostingController(rootView: self.buildSourceListView())
            self.state.rootTabCoordinator.goTo(destination: destination)
        }
        return view
        
    }
        
    private func updateActiveMediaControlPanel(activeMedia: ActiveMedia, device: MediaDevice) {
        state.mediaViewModel.hideSubView()
        self.state.activeMediaViewModel.selectedActiveMedia = activeMedia
        self.state.activeMediaViewModel.selectedActiveMediaDevice = device
        state.mediaViewModel.showSubView()
    }

}
    

//MARK: - Source Selection


extension ViewFactory {
    
    func buildMediaSourceSelection() -> MediaSourceSelection {
        let view = MediaSourceSelection(sourcesHScrollBuilder: buildSourcesHScrollView)
        return view
    }
    
    func buildSourcesHScrollView() -> SourcesHorizontalScroll {
        let view = SourcesHorizontalScroll(viewModel: state.mediaViewModel) { sourceType in
            self.state.rootTabCoordinator.goToWithParams(self.buildSourceListView(sourceType.id))
        }
        return view
    }
    
    func buildSourceListView(_ filter: SourceTypes = .camera) -> SourceList {
        let view = SourceList(sources: state.mediaViewModel, filter: filter) { source in
            self.state.activeMediaViewModel.assignSourceToMonitor(source: source)
            self.state.mediaViewModel.mediaViewIntentPublisher.send(.pairSpeakerWithMonitor)
            self.state.mediaViewModel.configureMediaViewIntent()
            self.state.mediaViewModel.clearMediaSelection()
            self.state.rootTabCoordinator.dismiss()
        }
        return view
    }
    
}
