//
//  ClimateModel.swift
//  MyCabin
//
//  Created by Lawless on 11/29/22.
//

import Foundation

struct ClimateControllerModel: Codable, Identifiable, Hashable, ElementModel {
    static func == (lhs: ClimateControllerModel, rhs: ClimateControllerModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    var id: String
    var name: String
    var rect:RenderCoordinates
    var side: String
    var sub: [String]?
    var assoc: [String]?
    var state: ClimateControllerState
}

struct ClimateControllerState: Codable {
    var temp: Int
    var setPoint: Int
    var sensor: Int
}
