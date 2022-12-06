//
//  MonitorsModel.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/28/22.
//

import Foundation

struct MonitorModel: Codable, Identifiable {
    var id: String
    var name: String
    var rect: RenderCoordinates
    var side: String
    var sub: [String]?
    struct assoc: Codable {
        var id: String
    }
    var type: String
    struct capabilities: Codable {
        var deploy: Bool
        var rotate: Bool
    }
    struct state: Codable {
        var on: Bool
        var source: String
        var sourceShortName: String
    }
}

struct MonitorPowerState: Codable {
    var on: Bool
}
