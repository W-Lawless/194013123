//
//  LightsModel.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/28/22.
//

import Foundation

enum LightState {
    var rawValue: Bool {
        return self == .ON ? true : false
    }
    
    case ON
    case OFF
}

struct LightModel: Codable, Identifiable, Hashable {
    static func == (lhs: LightModel, rhs: LightModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    var id: String = ""
    var name: String = ""
    var rect: RenderCoordinates = RenderCoordinates()
    var side: String = ""
    var sub: [String?] = [String?]()
    struct assoc: Codable {
        var id: String = ""
    }
    var type: String = ""
    struct color: Codable {
        var color_type: String = ""
        var palettes: [String]? = nil
    }
    var brightness: LightBrightness = LightBrightness()
    struct icons: Codable {
        var on: String = ""
        var off: String = ""
    }
    struct state: Codable, Equatable {
        var on: Bool = false
        var brightness: Int = 0
        
        static func == (lhs: LightModel.state, rhs: LightModel.state) -> Bool {
            return lhs.on == rhs.on && lhs.brightness == rhs.brightness
        }
    }
}

struct LightBrightness: Codable {
    var dimmable: Bool = false
    var range: [Int] = [Int]()
}
