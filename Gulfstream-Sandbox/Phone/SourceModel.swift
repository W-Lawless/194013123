//
//  SourcesModel.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/28/22.
//

import Foundation

struct SourceModel: Codable, Identifiable {
    var id: String
    var name: String
    var allowRename: Bool
    var defaultName: String
    var visible: Bool
    var order: Int
    struct rect: Codable {
        var x: Float
        var y: Float
        var w: Float
        var h: Float
        var r: Int
    }
    var side: String
    var sub: [String]?
    struct assoc: Codable {
        var id: String
    }
    var type: String
    struct capabilities: Codable {
        var audio: Bool
        var video: Bool
    }
    var shortName: String
    var personalDevice: Bool
    var seatOnly: Bool
}