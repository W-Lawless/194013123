//
//  PlaneViewModel.swift
//  MyCabin
//
//  Created by Lawless on 12/6/22.
//

import Foundation

class PlaneViewModel: ObservableObject {
    
    @Published var plane: PlaneMap = PlaneMap()
    @Published var planeDisplayOptions: PlaneSchematicDisplayMode = .onlySeats
    @Published var selectedZone: PlaneArea? = nil
    
    @Published var containerViewHeight: CGFloat = 0
    @Published var containerViewWidth: CGFloat = 0
    @Published var containerWidthUnit: CGFloat = 0
    @Published var containerHeightUnit: CGFloat = 0
    
    @Published var subviewHeightUnit: CGFloat = 0
    @Published var subviewWidthUnit: CGFloat = 0
    
    @MainActor func updateValues(_ data: PlaneMap) {
        self.plane = data
    }
    
    @MainActor func updateDisplayMode(_ mode: PlaneSchematicDisplayMode) {
        self.planeDisplayOptions = mode
    }
    
    func seatIconCallback(displayOptions: PlaneSchematicDisplayMode, seatID: String) {
        //TODO: - Refactor into view fac
//        switch displayOptions {
//        case .onlySeats:
//            UserDefaults.standard.set(seatID, forKey: "CurrentSeat")
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
//                NavigationFactory.homeMenuCoordinator.dismiss()
//            }
//        case .showLights:
//            UserDefaults.standard.set(seatID, forKey: "CurrentSeat")
//            StateFactory.lightsViewModel.showSubView(forID: seatID)
//        default:
//            break
//        }
    }
    
}

enum PlaneSchematicDisplayMode: String {
    case onlySeats
    case showLights
    case showShades
    case lightZones
    case tempZones
    case showMonitors
    case showNowPlaying
    case showSpeakers
    case showBluetooth
    case showRemote
}

struct Plane: Identifiable {
    var areas: [PlaneArea]
    var id: String
}

struct PlaneArea: Identifiable, Codable {
    var id: String = ""
    var rect: RenderCoordinates = RenderCoordinates()
    var lights: [LightModel]? = nil
    var seats: [SeatModel]? = nil
    var shades: [ShadeModel]? = nil
    var monitors: [MonitorModel]? = nil
    var speakers: [SpeakerModel]? = nil
    var sources: [SourceModel]? = nil
    var tables: [TableModel]? = nil
    var divans: [DivanModel]? = nil
    var zoneTemp: [ClimateControllerModel]? = nil
    var zoneLights: [LightModel]? = nil
}

struct PlaneMap: Codable {
    var parentArea: PlaneArea = PlaneArea()
    var mapAreas: [PlaneArea] = [PlaneArea]()   /// Full-bodied area struct with populated fields for lights, seats, etc 
    var apiAreas: [AreaModel] = [AreaModel]()  /// Areas as described by API results
    var allLights: [LightModel] = [LightModel]()
    var allSeats: [SeatModel] = [SeatModel]()
    var allMonitors: [MonitorModel] = [MonitorModel]()
    var allSpeakers: [SpeakerModel] = [SpeakerModel]()
    var allSources: [SourceModel] = [SourceModel]()
    var sourceTypes: Set<SourceType> = Set<SourceType>()
    var allShades: [ShadeModel] = [ShadeModel]()
    var allTables: [TableModel] = [TableModel]()
    var allDivans: [DivanModel] = [DivanModel]()
    var allTempCtrlrs: [ClimateControllerModel] = [ClimateControllerModel]()
}
      

    



