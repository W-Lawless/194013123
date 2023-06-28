//
//  ViewFactory+PlaneSchematic.swift
//  MyCabin
//
//  Created by Lawless on 6/27/23.
//

import SwiftUI

extension ViewFactory {
    
    func buildPlaneSchematic(options: PlaneSchematicDisplayMode) -> PlaneSchematic {
        Task { await state.planeViewModel.updateDisplayMode(options) }
        
        let view = PlaneSchematic(planeViewModel: state.planeViewModel,
                                  mediaViewModel: state.mediaViewModel,
                                  planeDisplayOptionsBarBuilder: buildPlaneDisplayOptionsBar,
                                  planeFuselageBuilder: buildPlaneFuselage)
        
        return view
    }
    
    func buildPlaneDisplayOptionsBar(options: PlaneSchematicDisplayMode) -> AnyView {
        switch (options) {
        case .showMonitors, .showSpeakers, .showNowPlaying, .showBluetooth, .showRemote:
            return AnyView(buildMediaDiplayOptionsBar())
        case .showLights:
            return AnyView(LightMenuPlaneDisplayOptions())
        case .lightZones:
            return AnyView(LightMenuPlaneDisplayOptions())
        case .showShades:
            return AnyView(ShadeMenuPlaneDisplayOptions())
        default:
            return AnyView(Text("").border(.green, width: 4))
        }
    }
    
    func buildPlaneFuselage() -> PlaneFuselage {
        let view = PlaneFuselage(areaSubViewBuilder: buildAreaSubView)
        return view
    }
    
    func buildAreaSubView(area: PlaneArea) -> AreaSubView {
        let view = AreaSubView(area: area, baseBlueprintBuilder: buildAreaBaseBlueprint, featureBlueprintBuilder: buildAreaFeatureBlueprint)
        return view
    }
    
    func buildAreaBaseBlueprint(area: PlaneArea) -> AreaBaseBlueprint {
        return AreaBaseBlueprint(area: area)
    }
    
    func buildAreaFeatureBlueprint(area: PlaneArea, options: PlaneSchematicDisplayMode) -> AnyView {
        
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
}

extension ViewFactory {
    
  func buildShadeBlueprint(area: PlaneArea) -> ShadeBlueprint {
      let view = ShadeBlueprint(area: area, shadeButtonBuilder: buildShadeButton)
      return view
  }
  
  func buildShadeButton(shade: ShadeModel) -> ShadeButton {
      let view = ShadeButton(viewModel: state.shadesViewModel, shade: shade)
      return view
  }
  
}

extension ViewFactory {
    
  func buildClimateBlueprint(area: PlaneArea) -> ClimateBlueprint {
      let view = ClimateBlueprint(areaClimateZones: area.zoneTemp ?? [ClimateControllerModel]())
      return view
  }
    
}
