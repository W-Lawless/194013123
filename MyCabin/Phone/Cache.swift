//
//  Cache.swift
//  MyCabin
//
//  Created by Lawless on 11/30/22.
//

import Foundation

struct FileCacheUtil {
    
    private static let encoder = JSONEncoder()
    private static let decoder = JSONDecoder()
    
    static func cacheToFile<T: Codable>(data: T) {
        do {
            let cacheDirectory = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("\(T.self).store")
            let dataEncoded = try encoder.encode(data)
            try dataEncoded.write(to: cacheDirectory)
            print("Data cached successfully")
        } catch {
            print(error)
        }
    }
    
    static func retrieveCachedFile<T: Codable>(dataModel: T.Type) throws -> T {
        print("retrieving cache", T.self)
        do {
            let cacheDirectory = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("\(T.self).store")
            let fileData = try Data(contentsOf: cacheDirectory)
            let out = try decoder.decode(T.self, from: fileData)
            return out
        } catch {
            throw error
        }
    }
    
    @MainActor static func loadAllCaches() throws {
        do {
            let cachedElements = try FileCacheUtil.retrieveCachedFile(dataModel: PlaneMap.self)
            let cachedLights = try FileCacheUtil.retrieveCachedFile(dataModel: [LightModel].self)
            let cachedSeats = try FileCacheUtil.retrieveCachedFile(dataModel: [SeatModel].self)
            let cachedMonitors = try FileCacheUtil.retrieveCachedFile(dataModel: [MonitorModel].self)
            let cachedSpeakers = try FileCacheUtil.retrieveCachedFile(dataModel: [SpeakerModel].self)
            let cachedSources = try FileCacheUtil.retrieveCachedFile(dataModel: [SourceModel].self)
            let cachedShades = try FileCacheUtil.retrieveCachedFile(dataModel: [ShadeModel].self)
            
            PlaneFactory.planeViewModel.updateValues(cachedElements)
            StateFactory.lightsViewModel.updateValues(cachedLights)
            StateFactory.seatsViewModel.updateValues(cachedSeats)
            StateFactory.monitorsViewModel.updateValues(cachedMonitors)
            StateFactory.speakersViewModel.updateValues(cachedSpeakers)
            StateFactory.sourcesViewModel.updateValues(cachedSources)
            StateFactory.shadesViewModel.updateValues(cachedShades)
        } catch {
            throw error
        }
    }
}

