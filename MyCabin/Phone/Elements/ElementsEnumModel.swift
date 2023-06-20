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

struct ElementsRoot: Codable {
    var results: [ElementsEnum]
    var length: Int
    
    init() {
        self.results = [ElementsEnum]()
        self.length = 0
    }
    
    init(results: [ElementsEnum], length: Int){
        self.results = results
        self.length = length
    }
    
}

enum ElementsEnum: Codable {
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
    case tempctrlr(ClimateControllerModel)
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
        case .TEMPCTRL:
            self = .tempctrlr(try typeContainer.decode(ClimateControllerModel.self))
        case .WATERH:
            self = .ignore(())
        case .WATERT:
            self = .ignore(())
        case .WATERS:
            self = .ignore(())
        case .WATERZ:
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
    
    func encode(to encoder: Encoder) throws {}
}

enum ElementTypes: String, Codable {
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

struct SourceType: Codable, Hashable {
    var id: SourceTypes
    var name: String
    var icon: SourceIcons
}

enum SourceTypes: String, Codable {
    case appleTV = "APPLE_TV"
    case aux = "AUX"
    case bluray = "BLURAY"
    case cabinView = "CABIN_VIEW"
    case camera = "CAMERA"
    case hdmi = "HDMI"
    case kaleid = "KALEIDESCAPE"
    case onDemand = "ON_DEMAND"
    case roku = "ROKU"
    case satTV = "SAT"
    case usbC = "USB_C"
    case xm = "XM"
}

enum SourceIcons: String, Codable {
    case appleTV = "ic_apple_tv"
    case aux = "ic_change_seat"
    case bluray = "ic_bluray"
    case cabinView = "ic_cabinview"
    case camera = "ic_cameras"
    case hdmi = "ic_change_devices"
    case kaleid = "ic_kaleidescape"
    case onDemand = "ic_ondemand"
    case roku = "ic_back_media"
    case satTV = "ic_livetv"
    case usbC = "ic_internal_connection"
    case xm = "ic_radio"
}

