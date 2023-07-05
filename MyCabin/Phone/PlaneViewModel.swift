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
    
    var screenWidth: CGFloat = 0
    var screenHeight: CGFloat = 0
    
    var containerWidthUnit: CGFloat = 0
    var containerHeightUnit: CGFloat = 0
    
    var heightOfAllAreas: CGFloat = 0
    var widthOfAllAreas: CGFloat = 0
    
    var subviewWidthUnit: CGFloat = 0
    var subviewHeightUnit: CGFloat = 0

    @MainActor func updateDisplayMode(_ mode: PlaneSchematicDisplayMode) {
        self.planeDisplayOptions = mode
    }
    
    func configureBaseUnits() {
        containerWidthUnit = (screenWidth * 0.39) / plane.parentArea.rect.w
        containerHeightUnit = (screenHeight) / plane.parentArea.rect.h
        
        configurePlaneSchematicParentContainer()
    }
    
    func configurePlaneSchematicParentContainer() {
//        print("AREAS:",plane.mapAreas.count)
        var heightValues = [CGFloat]()
        var widthValue: CGFloat = 0
        plane.mapAreas.forEach { area in
            let subviewHeight = containerHeightUnit * area.rect.h
            heightValues.append(subviewHeight)
            widthValue = containerWidthUnit * area.rect.w
            
            subviewHeightUnit = subviewHeight / area.rect.h
            subviewWidthUnit = widthValue / area.rect.w

            
            //TODO: - Check drawable on config with areas of variant sizes
//            let areaInternalHeightUnit = subviewHeight / area.rect.h
//            let areaInternalWidthUnit = subviewWidth / area.rect.w
        }
        var sumHeight: CGFloat = 0
        heightValues.forEach { value in
            sumHeight += value
        }
        heightOfAllAreas = sumHeight
        widthOfAllAreas = widthValue
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
      

    



