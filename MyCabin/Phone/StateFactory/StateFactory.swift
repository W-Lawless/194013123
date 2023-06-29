//
//  StateFactory.swift
//  MyCabin
//
//  Created by Lawless on 5/5/23.
//



final class StateFactory {
    
    typealias ElementsDictionary = [String:[Codable]]

    let api: APIFactory
    let cache: FileCacheUtil
    
    //Navigation
    let rootTabCoordinator = RootTabCoordinator()
    let homeMenuCoordinator = HomeMenuCoordinator()

    //Plane
    let planeViewModel = PlaneViewModel()
    var planeMap  = PlaneMap()
    var elementFormatter: ElementDataFormatter

    //Menu
    let lightsViewModel: LightsViewModel
    let shadesViewModel = ShadesViewModel()
    let climateViewModel = CabinClimateViewModel()
    

    //Media
    let mediaViewModel: MediaViewModel
    let activeMediaViewModel: ActiveMediaViewModel

    let monitorsViewModel = MonitorsViewModel()
    let speakersViewModel = SpeakersViewModel()
    
    //Flight
    let flightViewModel = FlightViewModel()
    let weatherViewModel = WeatherViewModel()
    
    init(api: APIFactory, cache: FileCacheUtil) {
        self.api = api
        self.cache = cache
        self.elementFormatter = ElementDataFormatter(cacheUtil: cache)
        
        self.lightsViewModel = LightsViewModel(plane: planeViewModel)
        self.mediaViewModel = MediaViewModel()//apiClient: self.api.apiClient)
        
        
        //TODO: -
        /// Give ActiveMediaVM, [Mon], [Sp] , [Src] to MediaVM
        self.activeMediaViewModel = ActiveMediaViewModel(mediaViewModel: mediaViewModel, monitorsViewModel: monitorsViewModel)
        
    }
}


extension StateFactory {

    func connectToPlane() {
        let elementsEndpoint = Endpoint<EndpointFormats.Get, ElementsEnum>(path: .elements)
        
        Task(priority: .high) {
            do {
                try await self.loadAllCaches()
            } catch {
                
                api.apiClient.fetch(for: elementsEndpoint) { res in
                    
                    let result = ElementsRoot(results: res, length: res.count)
                    
                    var dictionary = self.elementFormatter.mapResultsToDictionary(result: result)

                    self.elementFormatter.mapLightsToSeat(elements: &dictionary)

                    let sourceTypes = self.elementFormatter.findUniqueSourceTypes(elements: &dictionary)
                    self.mediaViewModel.updateSourceTypes(sourceTypes)
                    self.cache.cacheToFile(data: sourceTypes)
                    
                    self.planeMap = self.elementFormatter.buildPlaneMap(dictionary: dictionary, sourceSet: sourceTypes)

                    self.elementFormatter.mapElementsToPlaneAreas(allAreas: dictionary["allAreas"] as! [AreaModel], plane: &self.planeMap, elements: &dictionary)

                    self.elementFormatter.filterPlaneAreas(&self.planeMap)

                    self.planeViewModel.plane = self.planeMap //!

                    self.updateAndCachePlaneElements(elements: dictionary)
                    self.cache.cacheToFile(data: self.planeMap)
                }
                //TODO: - Climate View troubleshoot
                api.apiClient.fetchClimateControllers(climateViewModel: climateViewModel, cacheUtil: self.cache)
            }
        }
    }
    
    //TODO: Remove unsued view models . . .
    func updateAndCachePlaneElements(elements: ElementsDictionary, mockPath: String? = nil) {
        
        let allLights = elements["allLights"]! as! [LightModel]
        let allMonitors = elements["allMonitors"] as! [MonitorModel]
        let allSpeakers = elements["allSpeakers"] as! [SpeakerModel]
        let allSources = elements["allSources"] as! [SourceModel]
        let allShades = elements["allShades"] as! [ShadeModel]
        let tempCtrlrs = elements["allTempCtrlrs"] as! [ClimateControllerModel]
        
        lightsViewModel.updateValues(allLights)
        self.cache.cacheToFile(data: allLights, mockPath: mockPath)

        shadesViewModel.updateValues(allShades)
        self.cache.cacheToFile(data: allShades, mockPath: mockPath)

        climateViewModel.updateValues(tempCtrlrs)
        self.cache.cacheToFile(data: tempCtrlrs, mockPath: mockPath)

        mediaViewModel.updateMonitors(allMonitors)
        monitorsViewModel.updateValues(allMonitors)
        self.cache.cacheToFile(data: allMonitors, mockPath: mockPath)

        mediaViewModel.updateSpeakers(allSpeakers)
        speakersViewModel.updateValues(allSpeakers)
        self.cache.cacheToFile(data: allSpeakers, mockPath: mockPath)

        mediaViewModel.updateSourceList(allSources)
        self.cache.cacheToFile(data: allSources, mockPath: mockPath)
        
    }
    
    @MainActor func loadAllCaches() throws {
        do {
            let cachedElements = try self.cache.retrieveCachedFile(dataModel: PlaneMap.self)
            let cachedLights = try self.cache.retrieveCachedFile(dataModel: [LightModel].self)
            let cachedClimateControllers = try self.cache.retrieveCachedFile(dataModel: [ClimateControllerModel].self)
            let cachedMonitors = try self.cache.retrieveCachedFile(dataModel: [MonitorModel].self)
            let cachedSpeakers = try self.cache.retrieveCachedFile(dataModel: [SpeakerModel].self)
            let cachedSources = try self.cache.retrieveCachedFile(dataModel: [SourceModel].self)
            let cachedSourceTypes = try self.cache.retrieveCachedFile(dataModel: Set<SourceType>.self)
            let cachedShades = try self.cache.retrieveCachedFile(dataModel: [ShadeModel].self)
            
            planeViewModel.plane = cachedElements //!
            lightsViewModel.updateValues(cachedLights)
            shadesViewModel.updateValues(cachedShades)
            climateViewModel.updateValues(cachedClimateControllers)

            monitorsViewModel.updateValues(cachedMonitors)
            mediaViewModel.updateMonitors(cachedMonitors)
            
            speakersViewModel.updateValues(cachedSpeakers)
            mediaViewModel.updateSpeakers(cachedSpeakers)
            
            mediaViewModel.updateSourceList(cachedSources)
            mediaViewModel.updateSourceTypes(cachedSourceTypes)
            
        } catch {
            throw error
        }
    }
}
