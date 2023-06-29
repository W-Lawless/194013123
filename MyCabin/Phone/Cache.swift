//
//  Cache.swift
//  MyCabin
//
//  Created by Lawless on 11/30/22.
//

import Foundation

struct FileCacheUtil {
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func cacheToFile<T: Codable>(data: T, mockPath: String? = nil) {
        do {
            if let mockPath {
                let dataEncoded = try encoder.encode(data)
                let mockFilePath = "\(mockPath)/\(T.self).store"
                try FileManager.default.createDirectory(atPath: mockPath, withIntermediateDirectories: false)
                FileManager.default.createFile(atPath: mockFilePath, contents: dataEncoded)
            } else {
                let cacheDirectory = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("\(T.self).store")
                let dataEncoded = try encoder.encode(data)
                try dataEncoded.write(to: cacheDirectory)
            }
            print("Data cached successfully")
        } catch {
            print(error)
        }
    }
    
    func retrieveCachedFile<T: Codable>(dataModel: T.Type, mockPath: String? = nil) throws -> T {
        print("retrieving cache", T.self)
        do {
            if let mockPath {
                let mockFilePath = URL(fileURLWithPath: "\(mockPath)/\(T.self).store")
                let fileData = try Data(contentsOf: mockFilePath)
                let out = try decoder.decode(T.self, from: fileData)
                return out
            } else {
                let cacheDirectory = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("\(T.self).store")
                let fileData = try Data(contentsOf: cacheDirectory)
                let out = try decoder.decode(T.self, from: fileData)
                return out
            }
        } catch {
            print(error)
            throw error
        }
    }
    
}

