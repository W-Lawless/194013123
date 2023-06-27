//
//  ViewFactory+Media.swift
//  MyCabin
//
//  Created by Lawless on 6/27/23.
//

import SwiftUI


//MARK: - Monitors


extension ViewFactory {
    
    
    func buildMonitorsBlueprint(area: PlaneArea) -> MonitorsBlueprint {
        let view = MonitorsBlueprint(areaMonitors: area.monitors ?? [MonitorModel](), monitorButtonBuilder: buildMonitorButton)
        return view
    }
    
    func buildMonitorButton(viewIntent: MediaViewIntent, monitor: MonitorModel, selected: Bool) -> MonitorButton {
        let view = MonitorButton(monitor: monitor, selected: selected) { monitor in
            self.state.selectMonitor(monitor: monitor)
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
            self.state.selectSpeaker(speaker: speaker)
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
    
    func buildMediaSubView(viewIntent: MediaViewIntent) -> AnyView {
        switch (viewIntent) {
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
        let view = SourceList(sources: state.sourcesViewModel, filter: filter)
        return view
    }
    
}
