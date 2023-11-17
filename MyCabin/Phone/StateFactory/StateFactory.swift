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
    let lightsViewModel = LightsViewModel()
    let shadesViewModel = ShadesViewModel()
    let climateViewModel = CabinClimateViewModel()

    //Media
    let mediaViewModel = MediaViewModel()
    let activeMediaViewModel: ActiveMediaViewModel
    
    //Flight
    let flightViewModel = FlightViewModel()
    let weatherViewModel = WeatherViewModel()
    
    init(api: APIFactory, cache: FileCacheUtil) {
        self.api = api
        self.cache = cache
        self.elementFormatter = ElementDataFormatter(cacheUtil: cache)
        self.activeMediaViewModel = ActiveMediaViewModel(mediaViewModel: mediaViewModel, apiClient: api.apiClient)
    }
    
}

