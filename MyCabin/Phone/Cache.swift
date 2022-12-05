//
//  Cache.swift
//  MyCabin
//
//  Created by Lawless on 11/30/22.
//

import Foundation

struct FileCacheUtil {
    
    private static let encoder = JSONEncoder()
    
    static func cacheToFile<T: Codable>(data: Array<T>) {
        let key = T.self
        do {
            let jsonPath = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("\(key).json")
            let dataEncoded = try encoder.encode(data)
            try dataEncoded.write(to: jsonPath)
        } catch {
            print(error)
        }
    }
    
    
    static func retrieveCachedFile<T: Codable>(dataModel: T.Type) throws -> [T] {
        let jsonPath = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("\(dataModel.self).json")
        let fileData = try Data(contentsOf: jsonPath)
        let out = try JSONDecoder().decode([T].self, from: fileData)
        return out
    }
    
}

