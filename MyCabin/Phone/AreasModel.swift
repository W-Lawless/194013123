//
//  AreasModel.swift
//  MyCabin
//
//  Created by Lawless on 12/5/22.
//

import Foundation

struct AreaModel: Codable {
    var id: String
    var name: String
    var rect: AreaRender
    var side: String
    var sub: [SubArea]
    var assoc: [String]?
    struct icon_position: Codable {
        var x: Float
        var y: Float
    }
    var allowPrivacy: Bool
    var backlight: String
    var absoluteY: Float
    struct state: Codable {
        var privacy: Bool
    }
}

struct SubArea: Codable {
    var id: String
}

struct AreaRender: Codable {
    var x: Float
    var y: Float
    var w: Float
    var h: Float
    var r: Int
}
