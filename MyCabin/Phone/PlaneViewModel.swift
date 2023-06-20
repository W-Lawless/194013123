//
//  PlaneViewModel.swift
//  MyCabin
//
//  Created by Lawless on 12/6/22.
//

import Foundation

class PlaneViewModel: ObservableObject {
    @Published var plane: PlaneMap = PlaneMap()
    
    @MainActor func updateValues(_ data: PlaneMap) {
        print("Updating plane data")
        self.plane = data
//        print(data.mapAreas[0].lights)
    }
}

class PlaneViewCoordinates: ObservableObject {
    @Published var containerViewHeight: CGFloat = 0
    @Published var containerViewWidth: CGFloat = 0
    @Published var containerWidthUnit: CGFloat = 0
    @Published var containerHeightUnit: CGFloat = 0
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
    var id: String
    var rect: RenderCoordinates
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
    var parentArea: PlaneArea? = nil
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
      

    



