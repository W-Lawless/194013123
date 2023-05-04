//
//  ElementsEnumModel.swift
//  MyCabin
//
//  Created by Lawless on 12/7/22.
//

import Foundation

protocol ElementModel {
    var rect: RenderCoordinates { get set }
}

struct ElementsRoot: Decodable {
    var results: [ElementsEnum]
    var length: Int
}

enum ElementsEnum: Decodable {
    private enum CodingKeys: String, CodingKey { case elementType = "@type" }
    
    case light(LightModel)
    case seat(SeatModel)
    case speaker(SpeakerModel)
    case monitor(MonitorModel)
    case shade(ShadeModel)
    case source(SourceModel)
    case area(AreaModel)
    case table(TableModel)
    case divan(DivanModel)
    case ignore(Void)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let typeContainer = try decoder.singleValueContainer()
        let elementType = try container.decode(ElementTypes.self, forKey: .elementType)
        switch elementType {
        case .LIGHT:
            self = .light(try typeContainer.decode(LightModel.self))
        case .SEAT:
            self = .seat(try typeContainer.decode(SeatModel.self))
        case .SPEAKER:
            self = .speaker(try typeContainer.decode(SpeakerModel.self))
        case .MONITOR:
            self = .monitor(try typeContainer.decode(MonitorModel.self))
        case .WINDOW:
            self = .shade(try typeContainer.decode(ShadeModel.self))
        case .SOURCE:
            self = .source(try typeContainer.decode(SourceModel.self))
        case .AREA:
            self = .area(try typeContainer.decode(AreaModel.self))
        case .TABLE:
            self = .table(try typeContainer.decode(TableModel.self))
        case .DIVAN:
            self = .divan(try typeContainer.decode(DivanModel.self))
            
        case .WATERH:
            self = .ignore(())
        case .WATERT:
            self = .ignore(())
        case .WATERS:
            self = .ignore(())
        case .WATERZ:
            self = .ignore(())
        case .TEMPCTRL:
            self = .ignore(())
        case .BREAKER:
            self = .ignore(())
        case .BREAKERGROUP:
            self = .ignore(())
        case .VALVE:
            self = .ignore(())
        case .MONITORLIFT:
            self = .ignore(())
        case .AIRVENT:
            self = .ignore(())
        }
    }
}

enum ElementTypes: String, Decodable {
    case LIGHT = "Light"
    case SEAT = "Seat"
    case SPEAKER = "Speaker"
    case MONITOR = "Monitor"
    case WINDOW = "Window"
    case SOURCE = "Source"
    case WATERH = "WaterHeater"
    case WATERT = "Tank"
    case WATERS = "WaterSystem"
    case WATERZ = "WaterZone"
    case AREA = "Area"
    case TEMPCTRL = "TemperatureController"
    case AIRVENT = "AirVent"
    case BREAKER = "CircuitBreaker"
    case BREAKERGROUP = "CircuitBreakerGroup"
    case VALVE = "Valve"
    case TABLE = "Table"
    case DIVAN = "Divan"
    case MONITORLIFT = "MonitorLift"
}

