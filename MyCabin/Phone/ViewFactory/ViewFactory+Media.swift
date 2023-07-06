//
//  ViewFactory+Media.swift
//  MyCabin
//
//  Created by Lawless on 6/27/23.
//

import SwiftUI

extension ViewFactory {
    
    @ViewBuilder
    func buildMediaTab() -> some View {
        MediaTab(mediaViewModel: state.mediaViewModel,
                 activeMediaViewModel: state.activeMediaViewModel) {
            self.buildPlaneSchematic(self.state.mediaViewModel.planeDisplayOptions)
        } bottomPanel: {
            self.buildMediaSubView()
        }
    }
    
}

//MARK: - Options Bar

extension ViewFactory {
    
    @ViewBuilder
    func buildMediaDiplayOptionsBar() -> MediaOptions {
        MediaOptions(mediaOptionsButtonBuilder: buildMediaDisplayOptionButton)
    }
    
    @ViewBuilder
    func buildMediaDisplayOptionButton(image: String, option: PlaneSchematicDisplayMode) -> MediaOptionsButton {
        MediaOptionsButton(imageName: image, planeDisplayOptions: option)
    }
    
}


//MARK: - Monitors


extension ViewFactory {
    
    @ViewBuilder
    func buildMonitorsBlueprint(area: PlaneArea) -> MonitorsBlueprint {
        MonitorsBlueprint(areaMonitors: area.monitors ?? [MonitorModel](), monitorButtonBuilder: buildMonitorButton)
    }
    
    @ViewBuilder
    func buildMonitorButton(monitor: MonitorModel, selected: Bool) -> MonitorButton {
        MonitorButton(monitor: monitor, selected: selected) { monitor in
            switch(self.state.mediaViewModel.mediaViewIntentPublisher.value) {
            case .pairMonitorWithSpeaker:
                self.state.mediaViewModel.selectMonitor(monitor: monitor)
            default:
                print("Monitor Button built in Default Context")
                self.state.mediaViewModel.selectMonitor(monitor: monitor)
            }
        }
    }
    
}


//MARK: - Speakers


extension ViewFactory {
    
    @ViewBuilder
    func buildSpeakerBlueprint(area: PlaneArea) -> SpeakersBlueprint {
        SpeakersBlueprint(areaSpeakers: area.speakers ?? [SpeakerModel](), speakerButtonBuilder: buildSpeakerButton)
    }
    
    @ViewBuilder
    func buildSpeakerButton(speaker: SpeakerModel, selected: Bool) -> SpeakerButton {
        SpeakerButton(speaker: speaker, selected: selected) { speaker in
            switch(self.state.mediaViewModel.mediaViewIntentPublisher.value) {
            case .pairSpeakerWithMonitor:
                self.state.mediaViewModel.selectSpeaker(speaker: speaker)
            default:
                self.state.mediaViewModel.selectSpeaker(speaker: speaker)
            }
        }
    }
}


//MARK: - NowPlaying ActiveMedia


extension ViewFactory {
    
    @ViewBuilder
    func buildNowPlayingBluePrint(area: PlaneArea) -> NowPlayingBlueprint {
        NowPlayingBlueprint(area: area, activeMediaButtonGroupBuilder: buildActiveMediaButtonGroup)
    }
    
    func buildActiveMediaButtonGroup(area: PlaneArea, activeMedia: ActiveMedia) -> ActiveMediaButtonGroup {
        var speakersInArea = [SpeakerModel]()
        var monitorsInArea = [MonitorModel]()
        //var bluetoothDevicesInArea: [BluetoothDevice]
        //TODO: - Bluetooth
        
        activeMedia.speakers.forEach { speaker in
            if(speakerInArea(area: area, speaker: speaker)) {
                speakersInArea.append(speaker)
            }
        }
        
        activeMedia.monitors.forEach { monitor in
            if(monitorInArea(area: area, monitor: monitor)) {
                monitorsInArea.append(monitor)
            }
        }
        
        let view = ActiveMediaButtonGroup(activeMedia: activeMedia, speakers: speakersInArea, monitors: monitorsInArea, activeMediaDeviceButtonBuilder: buildActiveMediaDeviceButton)
        return view
    }
    
    @ViewBuilder
    func buildActiveMediaDeviceButton(activeMedia: ActiveMedia, deviceModel: MediaDeviceModel, device: MediaDevice) -> ActiveMediaDeviceButton {
        
        ActiveMediaDeviceButton(activeMedia: activeMedia, deviceModel: deviceModel, device: device) {
            
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
    
    @ViewBuilder
    func buildMediaSubView() -> some View {
        switch (self.state.mediaViewModel.mediaViewIntentPublisher.value) {
        case .viewNowPlaying:
            switch(self.state.mediaViewModel.planeDisplayOptions) {
            case .showNowPlaying:
                self.buildActiveMediaControlPanel(for: self.state.activeMediaViewModel.selectedActiveMedia,
                                                  on: self.state.activeMediaViewModel.selectedActiveMediaDevice)
            default:
                self.buildMediaSourceSelection()
            }
        case .pairSpeakerWithMonitor, .pairMonitorWithSpeaker:
            self.buildConfirmationSubView()
            
        default:
            self.buildMediaSourceSelection()
        }
    }
    
    @ViewBuilder
    func buildConfirmationSubView() -> ConfirmationSubView {
        ConfirmationSubView() {
            if(self.state.mediaViewModel.mediaViewIntentPublisher.value == .pairMonitorWithSpeaker) {
                self.state.activeMediaViewModel.assignSourceToMonitors()
            } else if (self.state.mediaViewModel.mediaViewIntentPublisher.value == .pairSpeakerWithMonitor){
                self.state.activeMediaViewModel.assignSourceToSpeakers()
            }
            self.state.activeMediaViewModel.completeOrClearActiveMediaSelection()
            self.state.mediaViewModel.mediaViewIntentPublisher.send(.viewNowPlaying)
            self.state.mediaViewModel.configureMediaViewIntent()
        }
    }
    
}

//MARK: - Active Media Control Panel

extension ViewFactory {
    
    @ViewBuilder
    func buildActiveMediaControlPanel(for activeMedia: ActiveMedia, on device: MediaDevice) -> ActiveMediaControlPanel {
        ActiveMediaControlPanel(activeMediaViewModel: state.activeMediaViewModel, activeMedia: activeMedia, device: device) {
            let destination = UIHostingController(rootView: self.buildSourceListView())
            self.state.rootTabCoordinator.goTo(destination: destination)
        }
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
    
    @ViewBuilder
    func buildMediaSourceSelection() -> MediaSourceSelection {
        MediaSourceSelection(sourcesHScrollBuilder: buildSourcesHScrollView)
    }
    
    @ViewBuilder
    func buildSourcesHScrollView() -> SourcesHorizontalScroll {
        SourcesHorizontalScroll(viewModel: state.mediaViewModel) { sourceType in
            self.state.rootTabCoordinator.goToWithParams(self.buildSourceListView(sourceType.id))
        }
    }
    
    @ViewBuilder
    func buildSourceListView(_ filter: SourceTypes = .camera) -> SourceList {
        SourceList(sources: state.mediaViewModel, filter: filter) { source in
            
            self.state.activeMediaViewModel.selectActiveSource(source)
            
            switch(self.state.mediaViewModel.planeDisplayOptions) {
            case .showMonitors:
                self.sourceAssignmentStartingWithMonitor()
            case .showSpeakers:
                self.sourceAssignmentStartingWithSpeaker()
            default:
                return
            }
        }
    }
    
    private func sourceAssignmentStartingWithMonitor() {
        state.activeMediaViewModel.assignSourceToMonitors()
        state.mediaViewModel.mediaViewIntentPublisher.send(.pairSpeakerWithMonitor)
        state.mediaViewModel.configureMediaViewIntent()
        state.mediaViewModel.clearMediaSelection()
        state.rootTabCoordinator.dismiss()
    }
    
    private func sourceAssignmentStartingWithSpeaker() {
        state.activeMediaViewModel.assignSourceToSpeakers()
        state.mediaViewModel.mediaViewIntentPublisher.send(.pairMonitorWithSpeaker)
        state.mediaViewModel.configureMediaViewIntent()
        state.mediaViewModel.clearMediaSelection()
        state.rootTabCoordinator.dismiss()
    }
    
}
