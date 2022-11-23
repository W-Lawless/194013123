//
//  CodableWrapper.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/17/22.
//

import Foundation

struct NetworkResponse<Wrapped: Codable>: Codable {
    var results: [Wrapped]
    var length: Int
}

struct EmptyResponse: Codable {
    var results: [String]?
    var length: Int?
}
