//
//  SeatModels.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/16/22.
//

import Foundation


//struct SeatsModel: Codable {
//    var results: [Seat]
//    var length: Int
//}

struct SeatModel: Codable, Identifiable {
    var id: String
    var name: String
    struct rect: Codable {
        var x: Float
        var y: Float
        var w: Float
        var h: Float
        var r: Float
    }
    var side: String
    var sub: [String?]
    var assoc: [Assoc?]
    var type: String
    var short_name: String
    var chirality: String
    struct state: Codable {
        var call: Bool
        var identifier: String
    }
}

struct StateModel: Codable {
    var results: [State]
    var length:Int
    struct State: Codable {
        var call: Bool
        var identifier: String
    }
}

struct Assoc: Codable {
    var decoratorType: String
    var id: String
    
    enum CodingKeys: String, CodingKey {
        case decoratorType = "@type"
        case id
    }
}
