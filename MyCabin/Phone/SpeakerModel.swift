//
//  SpeakerModel.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/28/22.
//

import Foundation

struct SpeakerModel: Codable, Identifiable {
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
