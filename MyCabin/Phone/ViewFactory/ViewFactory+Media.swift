//
//  ViewFactory+Media.swift
//  MyCabin
//
//  Created by Lawless on 6/27/23.
//

import SwiftUI

extension ViewFactory {
    
    func buildMediaTab() -> MediaTab {
        let view = MediaTab(//planeViewModel: state.planeViewModel,
                            mediaViewModel: state.mediaViewModel,
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
            switch(self.state.mediaViewIntentPublisher.value) {
            case .selectMonitorOutput:
                self.state.selectMonitor(monitor: monitor)
            case .selectSpeakerOutput:
                print("ayyy")
            case .viewNowPlaying:
                print("ayyyview now[palying ")
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
    
    //TODO: - Build out removes extra .mediavm from here vs ... statefactory+ files
    //TODO: if all mutation funcs moved into StF+ files VMs classes will be pure
    
    func buildSpeakerButton(speaker: SpeakerModel, selected: Bool) -> SpeakerButton {
        let view = SpeakerButton(speaker: speaker, selected: selected) { speaker in
            switch(self.state.mediaViewIntentPublisher.value) {
            case .selectMonitorOutput:
                self.state.selectSpeaker(speaker: speaker)
            case .selectSpeakerOutput:
                self.state.assignSourceToSpeaker(speaker: speaker)
            case .viewNowPlaying:
                print("noowwwplayin")
            }
        }
        
        return view
    }
}


//MARK: - NowPlaying


extension ViewFactory {
    
    func buildNowPlayingBluePrint(area: PlaneArea) -> NowPlayingBlueprint {
        let view = NowPlayingBlueprint(area: area, activeMediaButtonBuilder: buildActiveMediaButton)
        return view
    }
    
    func buildActiveMediaControlPanel(for activeMedia: ActiveMedia, on device: MediaDevice) -> ActiveMediaControlPanel {
        let view = ActiveMediaControlPanel(apiClient: state.apiClient, activeMedia: activeMedia, device: device) {
            let destination = UIHostingController(rootView: self.buildSourceListView())
            self.state.rootTabCoordinator.goTo(destination: destination)
        }
        return view
    }
    
    func buildActiveMediaButton(area: PlaneArea, activeMedia: ActiveMedia) -> ActiveMediaButton {
        let view = ActiveMediaButton(area: area, activeMedia: activeMedia)
        return view
    }
    
}


//MARK: - Subviews


extension ViewFactory {
    
    func buildMediaSubView() -> AnyView {
        switch (self.state.mediaViewIntentPublisher.value) {
        case .selectMonitorOutput:
            return AnyView(buildMediaSourceSeleciton())
        case .selectSpeakerOutput:
            return AnyView(buildSourcesHScrollView())
        case .viewNowPlaying:
            return AnyView(Text("Workin on it bos"))
            //            return AnyView(buildActiveMediaControlPanel(for: state.mediaViewModel.selectedActiveMedia, on: state.mediaViewModel.))
        }
    }
    
}
    

//MARK: - Select Source Subview


extension ViewFactory {
    
    func buildMediaSourceSeleciton() -> MediaSourceSelection {
        let view = MediaSourceSelection(sourcesHScrollBuilder: buildSourcesHScrollView)
        return view
    }
    
    func buildSourcesHScrollView() -> SourcesHorizontalScroll {
        let view = SourcesHorizontalScroll(viewModel: state.sourcesViewModel) { sourceType in
            self.state.rootTabCoordinator.goToWithParams(self.buildSourceListView(sourceType.id))
        }
        return view
    }
    
    func buildSourceListView(_ filter: SourceTypes = .camera) -> SourceList {
        let view = SourceList(sources: state.sourcesViewModel, filter: filter) { source in
            self.state.mediaViewModel.updateSelectedSource(source: source)
            self.state.assignSourceToMonitor(source: source) //TODO: LEFT OFF
            self.state.mediaViewIntentPublisher.send(.selectSpeakerOutput)
            self.state.configureMediaViewIntent()
            self.state.mediaViewModel.clearSelection()
            self.state.rootTabCoordinator.dismiss()
        }
        return view
    }
    
}
