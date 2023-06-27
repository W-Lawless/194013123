//
//  Cache.swift
//  MyCabin
//
//  Created by Lawless on 11/30/22.
//

import Foundation

struct FileCacheUtil {
    
    typealias ElementsDictionary = [String:[Codable]]
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    let state: StateFactory
    
    init(state: StateFactory) {
        self.state = state
    }
    
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
    
    //TODO: Consider removing entirely
    func updateAndCachePlaneElements(elements: ElementsDictionary, mockPath: String? = nil) {
        
        let allLights = elements["allLights"]! as! [LightModel]
        let allSeats = elements["allSeats"]! as! [SeatModel]
        let allMonitors = elements["allMonitors"] as! [MonitorModel]
        let allSpeakers = elements["allSpeakers"] as! [SpeakerModel]
        let allSources = elements["allSources"] as! [SourceModel]
        let allShades = elements["allShades"] as! [ShadeModel]
        let tempCtrlrs = elements["allTempCtrlrs"] as! [ClimateControllerModel]
        
        state.lightsViewModel.updateValues(allLights)
        cacheToFile(data: allLights, mockPath: mockPath)
        
        state.seatsViewModel.updateValues(allSeats)
        cacheToFile(data: allSeats, mockPath: mockPath)

        state.monitorsViewModel.updateValues(allMonitors)
        cacheToFile(data: allMonitors, mockPath: mockPath)

        state.speakersViewModel.updateValues(allSpeakers)
        cacheToFile(data: allSpeakers, mockPath: mockPath)

        state.sourcesViewModel.updateValues(allSources)
        cacheToFile(data: allSources, mockPath: mockPath)

        state.shadesViewModel.updateValues(allShades)
        cacheToFile(data: allShades, mockPath: mockPath)
        
        state.climateViewModel.updateValues(tempCtrlrs)
        cacheToFile(data: tempCtrlrs, mockPath: mockPath)
    }
    
    @MainActor func loadAllCaches() throws {
        do {
            let cachedElements = try retrieveCachedFile(dataModel: PlaneMap.self)
            let cachedLights = try retrieveCachedFile(dataModel: [LightModel].self)
            let cachedClimateControllers = try retrieveCachedFile(dataModel: [ClimateControllerModel].self)
            let cachedSeats = try retrieveCachedFile(dataModel: [SeatModel].self)
            let cachedMonitors = try retrieveCachedFile(dataModel: [MonitorModel].self)
            let cachedSpeakers = try retrieveCachedFile(dataModel: [SpeakerModel].self)
            let cachedSources = try retrieveCachedFile(dataModel: [SourceModel].self)
            let cachedSourceTypes = try retrieveCachedFile(dataModel: Set<SourceType>.self)
            let cachedShades = try retrieveCachedFile(dataModel: [ShadeModel].self)
            
            state.planeViewModel.updateValues(cachedElements)
            state.lightsViewModel.updateValues(cachedLights)
            state.climateViewModel.updateValues(cachedClimateControllers)
            state.seatsViewModel.updateValues(cachedSeats)
            state.monitorsViewModel.updateValues(cachedMonitors)
            state.speakersViewModel.updateValues(cachedSpeakers)
            state.sourcesViewModel.updateValues(cachedSources)
            state.sourcesViewModel.updateSourceTypes(cachedSourceTypes)
            state.shadesViewModel.updateValues(cachedShades)
        } catch {
            throw error
        }
    }
}

