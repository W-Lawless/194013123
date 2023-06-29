//
//  MonitorsModel.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/28/22.
//

import Foundation

struct MonitorModel: Codable, Identifiable, Hashable, ElementModel, MediaDeviceModel {
    
    static func == (lhs: MonitorModel, rhs: MonitorModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
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

struct MonitorSourceAssignment: Codable {
    var source: String
}
