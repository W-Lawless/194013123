//
//  SourcesModel.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/28/22.
//

import Foundation

struct SourceModel: Codable, Identifiable, Equatable, ElementModel, MediaDeviceModel {
    static func == (lhs: SourceModel, rhs: SourceModel) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: String = ""
    var name: String = ""
    var allowRename: Bool = true
    var defaultName: String = ""
    var visible: Bool = true
    var order: Int = 0
    var rect: RenderCoordinates = RenderCoordinates()
    var side: String = ""
    var sub: [String]? = nil
    struct assoc: Codable {
        var id: String = ""
    }
    var type: String = ""
    struct capabilities: Codable {
        var audio: Bool = true
        var video: Bool = true
    }
    var shortName: String = ""
    var personalDevice: Bool = true
    var seatOnly: Bool = true
}
