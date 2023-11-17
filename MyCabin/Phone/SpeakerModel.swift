//
//  SpeakerModel.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/28/22.
//

import Foundation

struct SpeakerModel: Codable, Identifiable, Hashable, ElementModel, MediaDeviceModel {
    var id: String = ""
    var name: String = ""
    var rect: RenderCoordinates = RenderCoordinates()
    var side: String = ""
    var sub: [String]? = nil
    var assoc: [String]? = nil
    var type: String = ""
    var state: SpeakerState = SpeakerState()
    
    
    static func == (lhs: SpeakerModel, rhs: SpeakerModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

struct SpeakerState: Codable {
    var mute: Bool = false
    var volume: Int = 0
    var source: String = ""
    var trebleLevel: Int = 0
    var bassLevel: Int = 0
    var shortSourceName: String? = nil
}


struct MuteCommand: Codable {
    var mute: Bool = false
}

struct VolumeCommand: Codable {
    var volume: Int = 0
}

struct SpeakerSourceAssignment: Codable {
    var source: String = ""
}
