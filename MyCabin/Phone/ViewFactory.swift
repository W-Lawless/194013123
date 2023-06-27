//
//  ViewFactory.swift
//  MyCabin
//
//  Created by Lawless on 5/5/23.
//

import Foundation
import SwiftUI


final class ViewFactory {
    
    // Coordinators
    static var AppCoordinator: AppCoordinator? = nil
    
    static let homeMenu = UIHostingController(rootView: buildMenuOverview())
    static let volumeMenu = UIHostingController(rootView: buildVolumeView())
    static let loadingView = UIHostingController(rootView: buildLoadingScreen())
    static let mediaTab = UIHostingController(rootView: buildMediaTab())
    static let flightTab = UIHostingController(rootView: buildFlightInfo())
    
    static func buildLoadingScreen() -> Loading {
        let view = Loading()
        return view
    }
    
    static func buildMenuOverview() -> Home {
        let view = Home(navigateTo: NavigationFactory.homeMenuCoordinator.goTo)
        return view
    }
    
    static func buildLightsMenu() -> Lights {
        let view = Lights(planeViewBuilder: PlaneFactory.buildPlaneSchematic, bottomPanelBuilder: buildLightsBottomPanel)
        return view
    }
    
    static func buildLightsBottomPanel() -> LightsBottomPanel {
        let view = LightsBottomPanel(viewModel: StateFactory.lightsViewModel)
        return view
    }
            
    static func buildSeatSelection() -> SeatSelection {
        let view = SeatSelection(viewModel: StateFactory.seatsViewModel, planeViewBuilder: PlaneFactory.buildPlaneSchematic)
        return view
    }
    
    static func buildShadesView() -> Shades {
        let view = Shades(viewModel: StateFactory.shadesViewModel, planeViewBuilder: PlaneFactory.buildPlaneSchematic)
        return view
    }
    
    
    static func buildCabinClimateView() -> CabinClimate {
        let view = CabinClimate(viewModel: StateFactory.climateViewModel, planeViewBuilder: PlaneFactory.buildPlaneSchematic)
        return view
    }
    

    static func buildMediaTab() -> MediaTab {
        let view = MediaTab(mediaViewModel: StateFactory.mediaViewModel, planeViewBuilder: PlaneFactory.buildPlaneSchematic)
        return view
    }
    
    static func buildActiveMediaControlPanel(for item: ActiveMedia, on device: MediaDevice) -> ActiveMediaControlPanel {
        let view = ActiveMediaControlPanel(mediaViewModel: StateFactory.mediaViewModel, activeMedia: item, device: device)
        return view
    }
    
    static func buildMonitorsView() -> Monitors {
        let view = Monitors(viewModel: StateFactory.monitorsViewModel)
        return view
    }
    
    static func buildSourcesView() -> Sources {
        let view = Sources(viewModel: StateFactory.sourcesViewModel)
        return view
    }
    
    static func buildSourceListView(_ filter: SourceTypes = .camera) -> SourceList {
        let view = SourceList(sources: StateFactory.sourcesViewModel, filter: filter)
        return view
    }
    
    static func buildSpeakersView() -> Speakers {
        let view = Speakers(viewModel: StateFactory.speakersViewModel)
        return view
    }
    
    
    static func buildVolumeView() -> Volume {
        let view = Volume(viewModel: StateFactory.speakersViewModel)
        return view
    }
    
    //Flight
    
    static func buildFlightInfo() -> FlightInfo {
        
        let viewModel = StateFactory.flightViewModel
        let startMonitor = StateFactory.flightAPI.monitor.startMonitor
        let monitorCallback = StateFactory.flightAPI.monitorCallback
        let stopMonitor = StateFactory.flightAPI.monitor.stopMonitor
        
        let view = FlightInfo(viewModel: viewModel , startMonitor: startMonitor, monitorCallback: monitorCallback, stopMonitor: stopMonitor)
        
        return view
    }
    
    static func buildWeatherView() -> Weather {
        
//        let viewModel = StateFactory.weatherViewModel
//        let startMonitor = StateFactory.weatherAPI.monitor.startMonitor
//        let monitorCallback = StateFactory.weatherAPI.monitorCallback
//        let stopMonitor = StateFactory.weatherAPI.monitor.stopMonitor
        
        let view = Weather(viewModel: StateFactory.weatherViewModel)
        return view
    }
    
    
    //MARK: - Plane Views
    
    static func buildPlaneFuselage() -> PlaneFuselage {
        let view = PlaneFuselage(areaSubViewBuilder: buildAreaSubView)
        return view
    }
    
    static func buildPlaneDisplayOptionsBar(options: PlaneSchematicDisplayMode) -> AnyView {
        switch (options) {
        case .showLights:
            return AnyView(LightMenuPlaneDisplayOptions())
        case .lightZones:
            return AnyView(LightMenuPlaneDisplayOptions())
        case .showShades:
            return AnyView(ShadeMenuPlaneDisplayOptions())
        default:
            return AnyView(Text(""))
        }
    }
    
    static func buildAreaSubView(area: PlaneArea) -> AreaSubView {
        let view = AreaSubView(area: area, baseBlueprintBuilder: buildAreaBaseBlueprint, featureBlueprintBuilder: buildAreaFeatureBlueprint)
        return view
    }
    
    static func buildAreaBaseBlueprint(area: PlaneArea) -> AreaBaseBlueprint {
        return AreaBaseBlueprint(area: area)
    }
    
    static func buildAreaFeatureBlueprint(area: PlaneArea, options: PlaneSchematicDisplayMode) -> AnyView {
        
        switch (options) {
        case .showShades:
            return AnyView(buildShadeBlueprint(area: area))
        case .showMonitors:
            return AnyView(buildMonitorsBlueprint(area: area))
        case .showSpeakers:
            return AnyView(buildSpeakerBlueprint(area: area))
        case .showNowPlaying:
            return AnyView(buildNowPlayingBluePrint(area: area))
        case .tempZones:
            return AnyView(buildClimateBlueprint(area: area))
        default:
            return AnyView(AreaBaseBlueprint(area: area))
        }
        
    }
    
    //MARK: - Lights
    
    
    
    //MARK: - Shades
    
    static func buildShadeBlueprint(area: PlaneArea) -> ShadeBlueprint {
        let view = ShadeBlueprint(area: area, shadeButtonBuilder: buildShadeButton)
        return view
    }
    
    static func buildShadeButton(shade: ShadeModel) -> ShadeButton {
        let view = ShadeButton(viewModel: StateFactory.shadesViewModel, shade: shade)
        return view
    }
    
    //MARK: - Climate
    
    static func buildClimateBlueprint(area: PlaneArea) -> ClimateBlueprint {
        let view = ClimateBlueprint(areaClimateZones: area.zoneTemp ?? [ClimateControllerModel]())
        return view
    }
    
    
    //MARK: - Media_Monitors
    
    static func buildMonitorsBlueprint(area: PlaneArea) -> MonitorsBlueprint {
        let view = MonitorsBlueprint(areaMonitors: area.monitors ?? [MonitorModel](), monitorButtonBuilder: buildMonitorButton)
        return view
    }
    
    //TODO: - Refactor passing callback from here
    static func buildMonitorButton(monitor: MonitorModel, selected: Bool) -> MonitorButton {
        let view = MonitorButton(monitor: monitor, selected: selected)
        return view
    }
    
    //MARK: - Media_Speakers
    
    static func buildSpeakerBlueprint(area: PlaneArea) -> SpeakersBlueprint {
        let view = SpeakersBlueprint(areaSpeakers: area.speakers ?? [SpeakerModel](), speakerButtonBuilder: buildSpeakerButton)
        return view
    }
    
    static func buildSpeakerButton(speaker: SpeakerModel, selected: Bool) -> SpeakerButton {
        let view = SpeakerButton(speaker: speaker, selected: selected)
        return view
    }
    
    //MARK: - Media_NowPlaying
    
    static func buildNowPlayingBluePrint(area: PlaneArea) -> NowPlayingBlueprint {
        let view = NowPlayingBlueprint(area: area, activeMediaButtonBuilder: buildActiveMediaButton)
        return view
    }
    
    static func buildActiveMediaButton(area: PlaneArea, activeMedia: ActiveMedia) -> ActiveMediaButton {
        let view = ActiveMediaButton(area: area, activeMedia: activeMedia)
        return view
    }
    
}
