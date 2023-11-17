//
//  SeatModels.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/16/22.
//

import Foundation


struct SeatModel: Codable, Identifiable, Equatable, Hashable, ElementModel {
    var id: String = ""
    var name: String = ""
    var rect: RenderCoordinates = RenderCoordinates()
    var side: String = ""
    var sub: [String?] = [String?]()
    var assoc: [Assoc?] = [Assoc?]()
    var type: String = ""
    var short_name: String = ""
    var chirality: String = ""
    struct state: Codable {
        var call: Bool = false
        var identifier: String = ""
    }
    var lights: [LightModel]? = nil
    
    static func == (lhs: SeatModel, rhs: SeatModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

struct StateModel: Codable {
    var results: [State] = [State]()
    var length:Int = 0
    struct State: Codable {
        var call: Bool = false
        var identifier: String = ""
    }
}

struct Assoc: Codable {
    var decoratorType: String = ""
    var id: String = ""
    
    enum CodingKeys: String, CodingKey {
        case decoratorType = "@type"
        case id
    }
}
