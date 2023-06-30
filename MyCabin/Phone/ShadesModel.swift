//
//  ShadesModel.swift
//  MyCabin
//
//  Created by Lawless on 5/3/23.
//

import Foundation

struct ShadeModel: Codable, Identifiable, ElementModel, Equatable {
    static func == (lhs: ShadeModel, rhs: ShadeModel) -> Bool {
        return lhs.id == rhs.id
    }
    
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
