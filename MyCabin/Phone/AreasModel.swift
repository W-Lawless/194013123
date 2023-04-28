//
//  AreasModel.swift
//  MyCabin
//
//  Created by Lawless on 12/5/22.
//

import Foundation

struct AreaModel: Codable, ElementModel {
    var id: String
    var name: String
    var rect: RenderCoordinates
    var side: String
    var sub: [SubElement]
    var assoc: [GroupElement]
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

struct SubElement: Codable {
    var type: String
    var id: String
    
    enum CodingKeys: String, CodingKey {
        case type = "@type"
        case id
    }
}

struct GroupElement: Codable {
    var type: String
    var id: String
    
    enum CodingKeys: String, CodingKey {
        case type = "@type"
        case id
    }
}


