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
    
    var id: String = ""
    var name: String = ""
    var rect: RenderCoordinates = RenderCoordinates()
    var side: String = ""
    var sub: [String]? = nil
    struct assoc: Codable {
        var id: String = ""
    }
    var type: String = ""
    struct capabilities: Codable {
        var deploy: Bool = false
        var rotate: Bool = false
    }
    struct state: Codable {
        var on: Bool = false
        var source: String = ""
        var sourceShortName: String = ""
    }
}

struct MonitorPowerState: Codable {
    var on: Bool = false
}

struct MonitorSourceAssignment: Codable {
    var source: String = ""
}
