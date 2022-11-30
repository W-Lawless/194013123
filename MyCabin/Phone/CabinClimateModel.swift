//
//  ClimateModel.swift
//  MyCabin
//
//  Created by Lawless on 11/29/22.
//

import Foundation

struct ClimateControllerModel: Codable, Identifiable {
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
    var state: ClimateControllerState
}

struct ClimateControllerState: Codable {
    var temp: Int
    var setPoint: Int
    var sensor: Int
}