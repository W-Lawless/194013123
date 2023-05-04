//
//  DivanModel.swift
//  MyCabin
//
//  Created by Lawless on 12/7/22.
//

import Foundation

struct DivanModel: Codable, Identifiable, ElementModel {
    var id: String
    var name: String
    var rect: RenderCoordinates
    var side: String
    var sub: [SubElement]
    var assoc: [SubElement]
    var divanType: String
    var hasArms: Bool
}
