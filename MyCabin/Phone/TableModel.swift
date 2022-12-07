//
//  TableModel.swift
//  MyCabin
//
//  Created by Lawless on 12/7/22.
//

import Foundation

struct TableModel: Codable {
    var id: String
    var name: String
    var rect: RenderCoordinates
    var side: String
    var sub: [SubElement]
    var assoc: [SubElement]
    var type: String
}
