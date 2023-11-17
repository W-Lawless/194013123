//
//  ViewFactory+PlaneSchematic.swift
//  MyCabin
//
//  Created by Lawless on 6/27/23.
//

import SwiftUI

extension ViewFactory {
    
    func buildPlaneSchematic(_ displayOption: PlaneSchematicDisplayMode) -> some View {
        
        Task { await self.state.planeViewModel.updateDisplayMode(displayOption) }
        let view = PlaneSchematic(planeViewModel: state.planeViewModel,
                       mediaViewModel: state.mediaViewModel) {
            self.buildPlaneDisplayOptionsBar(options: self.state.planeViewModel.planeDisplayOptions)
        } planeFuselage:{
            self.buildPlaneFuselage()
        }
        
        return view
        
    }
    
    @ViewBuilder
    func buildPlaneDisplayOptionsBar(options: PlaneSchematicDisplayMode) -> some View {
        switch (options) {
        case .showMonitors, .showSpeakers, .showNowPlaying, .showBluetooth, .showRemote:
            buildMediaDiplayOptionsBar()
        case .showLights:
            LightMenuPlaneDisplayOptions()
        case .lightZones:
            LightMenuPlaneDisplayOptions()
        case .showShades:
            ShadeMenuPlaneDisplayOptions()
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    func buildPlaneFuselage() -> some View {
        PlaneFuselage() {
            ZStack {
                VStack(spacing:0) {
                    ForEach(self.state.planeViewModel.plane.mapAreas) { area in
                        self.buildAreaSubView(area: area)
                            .if(self.state.planeViewModel.planeDisplayOptions == .lightZones) {
                                $0.modifier(TappableZone(area: area))
                            }
                    } //: FOREACH
                } //: VSTQ
                if(self.state.planeViewModel.planeDisplayOptions == .tempZones) {
                    self.buildClimateBlueprint()
                }
            } //:ZSTQ
        } //:PLANEFUSELAGE
    }
    
    @ViewBuilder
    func buildAreaSubView(area: PlaneArea) -> some View {
        AreaSubView() {
            self.buildAreaSubViewZStack(area: area)
        }
    }
    
    @ViewBuilder
    func buildAreaSubViewZStack(area: PlaneArea) -> some View {
        ZStack(alignment: .topLeading) {
            self.buildAreaBaseBlueprint(area: area)
            self.buildAreaFeatureBlueprint(area: area)
        }
        .frame(width: self.state.planeViewModel.subviewWidthUnit * area.rect.w, height: self.state.planeViewModel.subviewHeightUnit * area.rect.h)
        .if(self.state.planeViewModel.planeDisplayOptions == .lightZones) { view in
            view
                .opacity(self.state.planeViewModel.selectedZone?.id == area.id ? 1 : 0.3)
                .background(self.state.planeViewModel.selectedZone?.id == area.id ? Color.yellow.opacity(0.3) : nil)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
    
    @ViewBuilder
    func buildAreaBaseBlueprint(area: PlaneArea) -> some View {
        AreaBaseBlueprint(area: area) { (id, selected) in
            self.buildSeatButton(id: id, selected: selected)
        }
    }
    
    @ViewBuilder
    func buildAreaFeatureBlueprint(area: PlaneArea) -> some View {
        switch (self.state.planeViewModel.planeDisplayOptions) {
        case .showShades:
            buildShadeBlueprint(area: area)
        case .showMonitors:
            buildMonitorsBlueprint(area: area)
        case .showSpeakers:
            buildSpeakerBlueprint(area: area)
        case .showNowPlaying:
            buildNowPlayingBluePrint(area: area)
        default:
            EmptyView()
        }
        
    }
}

//MARK: - Seat Buttons

extension ViewFactory {
    
    @ViewBuilder
    func buildSeatButton(id: String, selected: Bool) -> some View {
        SeatButton(id: id, selected: selected) { (displayOptions, seatID) in
            switch displayOptions {
            case .onlySeats:
                UserDefaults.standard.set(seatID, forKey: "CurrentSeat")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.state.homeMenuCoordinator.dismiss()
                }
            case .showLights:
                UserDefaults.standard.set(seatID, forKey: "CurrentSeat")
                self.state.lightsViewModel.showSubView(forID: seatID)
            default:
                break
            }
        }
    }
    
}

//MARK: - Shade Buttons

extension ViewFactory {
    
    @ViewBuilder
    func buildShadeBlueprint(area: PlaneArea) -> some View {
        ShadeBlueprint(area: area) { shade in
            self.buildShadeButton(shade: shade)
        }
    }
    
    @ViewBuilder
    func buildShadeButton(shade: ShadeModel) -> some View {
        ShadeButton(viewModel: state.shadesViewModel, shade: shade)
    }
    
}

//MARK: - Climate 

extension ViewFactory {
    
    @ViewBuilder
    func buildClimateBlueprint() -> some View {
        ClimateBlueprint(areaClimateZones: self.state.planeViewModel.plane.parentArea.zoneTemp ?? [ClimateControllerModel]())
    }
    
}
