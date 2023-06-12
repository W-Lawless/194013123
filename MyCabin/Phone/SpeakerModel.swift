//
//  SpeakerModel.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/28/22.
//

import Foundation

struct SpeakerModel: Codable, Identifiable, ElementModel, MediaModel {
    var id: String
    var name: String
    var rect: RenderCoordinates
    var side: String
    var sub: [String]?
    var assoc: [String]?
    var type: String
    var state: SpeakerState
}

struct SpeakerState: Codable {
    var mute: Bool
    var volume: Int
    var source: String
    var trebleLevel: Int
    var bassLevel: Int
    var shortSourceName: String?
}


struct MuteCommand: Codable {
    var mute: Bool
}

struct VolumeCommand: Codable {
    var volume: Int
}

struct SpeakerSourceAssignment: Codable {
    var source: String
}
