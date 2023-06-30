//
//  ViewFactory+PlaneSchematic.swift
//  MyCabin
//
//  Created by Lawless on 6/27/23.
//

import SwiftUI

extension ViewFactory {
    
    func buildPlaneSchematic(options: PlaneSchematicDisplayMode) -> PlaneSchematic {
        Task {
            print("*** update to", options.rawValue)
            await state.planeViewModel.updateDisplayMode(options)
            print("*** updated to", state.planeViewModel.planeDisplayOptions)
            
        }
        
        let view = PlaneSchematic(planeViewModel: state.planeViewModel,
                                  mediaViewModel: state.mediaViewModel,
                                  planeDisplayOptionsBarBuilder: buildPlaneDisplayOptionsBar,
                                  planeFuselageBuilder: buildPlaneFuselage)
        
        return view
    }
    
    //TODO: - Use ViewBuilder to remove AnyView bs?
    //TODO: - Use some View to remove anyview ?
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
            return AnyView(Text(""))
        }
    }
    
    func buildPlaneFuselage() -> PlaneFuselage {
        let view = PlaneFuselage(areaSubViewBuilder: buildAreaSubView)
        return view
    }
    
    func buildAreaSubView(area: PlaneArea) -> AreaSubView {
        let view = AreaSubView(area: area, baseBlueprintBuilder: self.buildAreaBaseBlueprint, featureBlueprintBuilder: self.buildAreaFeatureBlueprint)
        return view
    }
    
    func buildAreaBaseBlueprint(area: PlaneArea) -> AreaBaseBlueprint {
        return AreaBaseBlueprint(area: area, seatButtonBuilder: buildSeatButton)
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
            return AnyView(AreaBaseBlueprint(area: area, seatButtonBuilder: buildSeatButton))
        }
        
    }
}

//MARK: - Seat Buttons

extension ViewFactory {
    
    func buildSeatButton(id: String, selected: Bool) -> SeatButton {
        let view = SeatButton(id: id, selected: selected) { (displayOptions, seatID) in
            switch displayOptions {
            case .onlySeats:
                UserDefaults.standard.set(seatID, forKey: "CurrentSeat")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    self.state.homeMenuCoordinator.dismiss()
                }
            case .showLights:
                UserDefaults.standard.set(seatID, forKey: "CurrentSeat")
                self.state.lightsViewModel.showSubView(forID: seatID)
            default:
                break
            }
        }
        return view
    }
    
}

//MARK: - Shade Buttons

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

//MARK: - Climate 

extension ViewFactory {
    
  func buildClimateBlueprint(area: PlaneArea) -> ClimateBlueprint {
//      print("*** building cabin climate blueprint")
      let view = ClimateBlueprint(areaClimateZones: area.zoneTemp ?? [ClimateControllerModel]())
      return view
  }
    
}
