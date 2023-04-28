//
//  AccessModel.swift
//  MyCabin
//
//  Created by Lawless on 12/1/22.
//

import Foundation

struct AccessModel: Codable, ElementModel {
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

struct DeviceModel: Codable {
    var id: String
    var name: String
    var label: String
    var ipAddress: String
    var macAddress: String
    var accessLevel: String
    var enabled: Bool
    var immutable: Bool
    var pin: String
    var accessLevelRequested: Bool
    var deviceType: String
    var createdAt: Int
    var lastSeenAt: Int
}

