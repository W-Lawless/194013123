//
//  FlightModels.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/16/22.
//

import Foundation

struct FlightModel: Codable, Equatable {
    var latitude: Double
    var longitude: Double
    var altitude: Int
    var air_speed: Int
    var ground_speed: Int
    var estimated_arrival: Int
    var destination_timezone: String
    var time_remaining: Int
    var current_time: Int
    var total_time: Int
    var external_temperature: Int
    var forward_cabin_temp: Int
    var aft_cabin_temp: Int
    var on_ground: Bool
    var mach: Double
    var mode: Bool
}
