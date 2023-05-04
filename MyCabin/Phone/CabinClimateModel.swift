//
//  ClimateModel.swift
//  MyCabin
//
//  Created by Lawless on 11/29/22.
//

import Foundation

struct ClimateControllerModel: Codable, Identifiable, ElementModel {
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
