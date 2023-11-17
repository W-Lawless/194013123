//
//  StateFactory+.swift
//  MyCabin
//
//  Created by Lawless on 6/28/23.
//

extension StateFactory {
    
    func connectToPlane() {
        let elementsEndpoint = Endpoint<EndpointFormats.Get, ElementsEnum>(path: .elements)
        
        do {
            try self.loadAllCaches()
        } catch {
            
            api.apiClient.fetch(for: elementsEndpoint) { res in
                
                let result = ElementsRoot(results: res, length: res.count)
                
                var dictionary = self.elementFormatter.mapResultsToDictionary(result: result)

                self.elementFormatter.mapLightsToSeat(elements: &dictionary)
                
                let sourceTypes = self.elementFormatter.findUniqueSourceTypes(elements: &dictionary)
                
                self.planeMap = self.elementFormatter.buildPlaneMap(dictionary: dictionary, sourceSet: sourceTypes)
                
                self.elementFormatter.mapElementsToPlaneAreas(allAreas: dictionary["allAreas"] as! [AreaModel], plane: &self.planeMap, elements: &dictionary)
                
                self.elementFormatter.filterPlaneAreas(&self.planeMap)
                
                self.planeViewModel.configureBaseUnits()
                
                self.updateAndCacheViewModels(elements: dictionary, sourceTypes: sourceTypes)
            }
        }
        
    }
    
    func updateAndCacheViewModels(elements: ElementsDictionary,
                                  mockPath: String? = nil,
                                  sourceTypes: Set<SourceType>) {
        
        let allLights = elements["allLights"]! as! [LightModel]
        let allSeats = elements["allSeats"] as! [SeatModel]
        let allMonitors = elements["allMonitors"] as! [MonitorModel]
        let allSpeakers = elements["allSpeakers"] as! [SpeakerModel]
        let allSources = elements["allSources"] as! [SourceModel]
        let allShades = elements["allShades"] as! [ShadeModel]
        let tempCtrlrs = elements["allTempCtrlrs"] as! [ClimateControllerModel]
        
        planeViewModel.plane = self.planeMap
        cache.cacheToFile(data: self.planeMap)
        
        lightsViewModel.updateLights(allLights)
        lightsViewModel.updateSeats(allSeats)
        
        cache.cacheToFile(data: allLights, mockPath: mockPath)
        cache.cacheToFile(data: allSeats, mockPath: mockPath)
        
        shadesViewModel.updateShades(allShades)
        cache.cacheToFile(data: allShades, mockPath: mockPath)
        
        climateViewModel.updateValues(tempCtrlrs)
        cache.cacheToFile(data: tempCtrlrs, mockPath: mockPath)
        
        mediaViewModel.updateMonitors(allMonitors)
        mediaViewModel.updateSpeakers(allSpeakers)
        mediaViewModel.updateSourceList(allSources)
        mediaViewModel.updateSourceTypes(sourceTypes)
        
        cache.cacheToFile(data: sourceTypes)
        cache.cacheToFile(data: allMonitors, mockPath: mockPath)
        cache.cacheToFile(data: allSpeakers, mockPath: mockPath)
        cache.cacheToFile(data: allSources, mockPath: mockPath)
        
    }
    
    func loadAllCaches() throws {
        do {
            let cachedElements = try cache.retrieveCachedFile(dataModel: PlaneMap.self)
            let cachedLights = try cache.retrieveCachedFile(dataModel: [LightModel].self)
            let cachedSeats = try cache.retrieveCachedFile(dataModel: [SeatModel].self)
            let cachedClimateControllers = try cache.retrieveCachedFile(dataModel: [ClimateControllerModel].self)
            let cachedMonitors = try cache.retrieveCachedFile(dataModel: [MonitorModel].self)
            let cachedSpeakers = try cache.retrieveCachedFile(dataModel: [SpeakerModel].self)
            let cachedSources = try cache.retrieveCachedFile(dataModel: [SourceModel].self)
            let cachedSourceTypes = try cache.retrieveCachedFile(dataModel: Set<SourceType>.self)
            let cachedShades = try cache.retrieveCachedFile(dataModel: [ShadeModel].self)
            
            planeViewModel.plane = cachedElements
            
            lightsViewModel.updateLights(cachedLights)
            lightsViewModel.updateSeats(cachedSeats)
            
            shadesViewModel.updateShades(cachedShades)
            
            climateViewModel.updateValues(cachedClimateControllers)
            
            mediaViewModel.updateMonitors(cachedMonitors)
            mediaViewModel.updateSpeakers(cachedSpeakers)
            mediaViewModel.updateSourceList(cachedSources)
            mediaViewModel.updateSourceTypes(cachedSourceTypes)
            
            planeViewModel.configureBaseUnits()
            print("*** Cache hit ***")
        } catch {
            print("*** Cache miss ***", error)
            throw error
        }
    }
}
