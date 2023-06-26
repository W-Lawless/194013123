//
//  Cache.swift
//  MyCabin
//
//  Created by Lawless on 11/30/22.
//

import Foundation

struct FileCacheUtil {
    
    typealias ElementsDictionary = [String:[Codable]]
    private static let encoder = JSONEncoder()
    private static let decoder = JSONDecoder()
    
    static func cacheToFile<T: Codable>(data: T, mockPath: String? = nil) {
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
    
    static func retrieveCachedFile<T: Codable>(dataModel: T.Type, mockPath: String? = nil) throws -> T {
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
    
    //TODO: Consider removing entirely
    static func updateAndCachePlaneElements(elements: ElementsDictionary, mockPath: String? = nil) {
        
        let allLights = elements["allLights"]! as! [LightModel]
        let allSeats = elements["allSeats"]! as! [SeatModel]
        let allMonitors = elements["allMonitors"] as! [MonitorModel]
        let allSpeakers = elements["allSpeakers"] as! [SpeakerModel]
        let allSources = elements["allSources"] as! [SourceModel]
        let allShades = elements["allShades"] as! [ShadeModel]
        let tempCtrlrs = elements["allTempCtrlrs"] as! [ClimateControllerModel]
        
        StateFactory.lightsViewModel.updateValues(allLights)
        cacheToFile(data: allLights, mockPath: mockPath)
        
        StateFactory.seatsViewModel.updateValues(allSeats)
        cacheToFile(data: allSeats, mockPath: mockPath)

        StateFactory.monitorsViewModel.updateValues(allMonitors)
        cacheToFile(data: allMonitors, mockPath: mockPath)

        StateFactory.speakersViewModel.updateValues(allSpeakers)
        cacheToFile(data: allSpeakers, mockPath: mockPath)

        StateFactory.sourcesViewModel.updateValues(allSources)
        cacheToFile(data: allSources, mockPath: mockPath)

        StateFactory.shadesViewModel.updateValues(allShades)
        cacheToFile(data: allShades, mockPath: mockPath)
        
        StateFactory.climateViewModel.updateValues(tempCtrlrs)
        cacheToFile(data: tempCtrlrs, mockPath: mockPath)
    }
    
    @MainActor static func loadAllCaches() throws {
        do {
            let cachedElements = try FileCacheUtil.retrieveCachedFile(dataModel: PlaneMap.self)
            let cachedLights = try FileCacheUtil.retrieveCachedFile(dataModel: [LightModel].self)
            let cachedClimateControllers = try FileCacheUtil.retrieveCachedFile(dataModel: [ClimateControllerModel].self)
            let cachedSeats = try FileCacheUtil.retrieveCachedFile(dataModel: [SeatModel].self)
            let cachedMonitors = try FileCacheUtil.retrieveCachedFile(dataModel: [MonitorModel].self)
            let cachedSpeakers = try FileCacheUtil.retrieveCachedFile(dataModel: [SpeakerModel].self)
            let cachedSources = try FileCacheUtil.retrieveCachedFile(dataModel: [SourceModel].self)
            let cachedSourceTypes = try FileCacheUtil.retrieveCachedFile(dataModel: Set<SourceType>.self)
            let cachedShades = try FileCacheUtil.retrieveCachedFile(dataModel: [ShadeModel].self)
            
            PlaneFactory.planeViewModel.updateValues(cachedElements)
            StateFactory.lightsViewModel.updateValues(cachedLights)
            StateFactory.climateViewModel.updateValues(cachedClimateControllers)
            StateFactory.seatsViewModel.updateValues(cachedSeats)
            StateFactory.monitorsViewModel.updateValues(cachedMonitors)
            StateFactory.speakersViewModel.updateValues(cachedSpeakers)
            StateFactory.sourcesViewModel.updateValues(cachedSources)
            StateFactory.sourcesViewModel.updateSourceTypes(cachedSourceTypes)
            StateFactory.shadesViewModel.updateValues(cachedShades)
        } catch {
            throw error
        }
    }
}

