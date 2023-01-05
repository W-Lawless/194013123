//
//  Cache.swift
//  MyCabin
//
//  Created by Lawless on 11/30/22.
//

import Foundation

struct FileCacheUtil {
    
    private static let encoder = JSONEncoder()
    
    static func cacheToFile<T: Codable>(data: T) {
        do {
            let cacheDirectory = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("com.gulfstreamaero.myCabin.store")
            let dataEncoded = try encoder.encode(data)
            try dataEncoded.write(to: cacheDirectory)
            print("Data cached successfully")
        } catch {
            print(error)
        }
    }
    
    static func retrieveCachedFile<T: Codable>(dataModel: T) throws -> T {
        print("retrieving cache")
        do {
            let cacheDirectory = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("com.gulfstreamaero.myCabin.store")
            let fileData = try Data(contentsOf: cacheDirectory)
            let out = try JSONDecoder().decode(T.self, from: fileData)
            return out
        } catch {
            throw error
        }
    }
}

