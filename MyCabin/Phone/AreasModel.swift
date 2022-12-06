//
//  AreasModel.swift
//  MyCabin
//
//  Created by Lawless on 12/5/22.
//

import Foundation

enum ElementTypes: String {
    case LIGHT = "Light"
    case SEAT = "Seat"
    case SPEAKER = "Speaker"
    case MONITOR = "Monitor"
    case WINDOW = "Window"
    case SOURCE = "Source"
    case WATERH = "WaterHeater"
    case WATERT = "Tank"
    case WATERS = "WaterSystem"
    case AREA = "Area"
    case TEMPCTRL = "TemperatureController"
    case BREAKER = "CircuitBreaker"
}

struct AreaModel: Codable {
    var id: String
    var name: String
    var rect: RenderCoordinates
    var side: String
    var sub: [SubElement]
    var assoc: [GroupElement]
    struct icon_position: Codable {
        var x: Float
        var y: Float
    }
    var allowPrivacy: Bool
    var backlight: String
    var absoluteY: Float
    struct state: Codable {
        var privacy: Bool
    }
}

struct SubElement: Codable {
    var type: String
    var id: String
    
    enum CodingKeys: String, CodingKey {
        case type = "@type"
        case id
    }
}

struct GroupElement: Codable {
    var type: String
    var id: String
    
    enum CodingKeys: String, CodingKey {
        case type = "@type"
        case id
    }
}





struct Plane: Identifiable {
    var areas: [PlaneArea]
    var id: String
}

struct PlaneArea: Identifiable {
    var id: String
    var rect: RenderCoordinates
    var lights: [LightModel]?
    var seats: [SeatModel]?
    var shades: [ShadeModel]?
    var monitors: [MonitorModel]?
    var speakers: [SpeakerModel]?
    var sources: [SourceModel]?
    var zoneTemp: [ClimateControllerModel]?
    var zoneLights: [LightModel]?
}
