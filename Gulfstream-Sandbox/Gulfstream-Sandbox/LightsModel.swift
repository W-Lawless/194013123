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

struct LightModel: Codable, Identifiable {
    var id: String
    var name: String
    struct rect: Codable {
        var x: Float
        var y: Float
        var w: Float
        var h: Float
        var r: Int
    }
    var side: String
    var sub: [String?]
    struct assoc: Codable {
        var id: String
    }
    var type: String
    struct color: Codable {
        var color_type: String
        var palettes: [String]?
    }
    struct brightness: Codable {
        var dimmable: Bool
        var range: [Int]
    }
    struct icons: Codable {
        var on: String
        var off: String
    }
    struct state: Codable {
        var on: Bool
        var brightness: Int
    }
}
