//
//  Cache.swift
//  MyCabin
//
//  Created by Lawless on 11/30/22.
//

import Foundation

struct FileCacheUtil {
    
    private static let encoder = JSONEncoder()
    
    static func cacheToFile<T: Codable>(data: Array<T>) throws {
        do {
            let cacheDirectory = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("com.gulfstreamaero.myCabin.store")
            let dataEncoded = try encoder.encode(data)
            try dataEncoded.write(to: cacheDirectory)
        } catch {
            throw error
        }
    }
    
    
    static func retrieveCachedFile<T: Codable>(dataModel: T.Type) throws -> [T] {
        do {
            let cacheDirectory = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("com.gulfstreamaero.myCabin.store")
            let fileData = try Data(contentsOf: cacheDirectory)
            let out = try JSONDecoder().decode([T].self, from: fileData)
            return out
        } catch {
            return error
        }
    }
    
}

