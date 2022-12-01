//
//  AccessModel.swift
//  MyCabin
//
//  Created by Lawless on 12/1/22.
//

import Foundation

struct AccessModel: Codable {
    var id: String
    var name: String
    var system: Bool
    var visible: Bool
    var defaultSetting: Bool
    var description: String
    var roles: [String]?
    var capabilities: AccessCapabilities
    var components: AccessComponents
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case system
        case visible
        case description
        case defaultSetting = "default"
        case roles
        case capabilities
        case components
    }
}

struct AccessCapabilities: Codable {
    var manageAreas: Bool
    var managePresets: Bool
    var manageElements: Bool
}

struct AccessComponents: Codable {
    var areas: [String]
    var presets: [String]
    var elements: [String]
}

