//
//  ShadesModel.swift
//  MyCabin
//
//  Created by Lawless on 5/3/23.
//

import Foundation

struct ShadeCommand: Codable {
    var cmd: String
}

enum ShadeStates: String {
    case OPEN
    case CLOSE
    case SHEER
}

struct ShadeModel: Codable, Identifiable, ElementModel {
    var id: String
    var name: String
    var side: String
    var rect: RenderCoordinates
    var sub: [String?]
    var assoc: [String?]
    struct capabilities: Codable {
        var position: Bool
        var fabricCount: Int
        var shadeCommands: [String]
    }
}
