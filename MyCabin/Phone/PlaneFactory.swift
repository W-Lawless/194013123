//
//  LoadAll.swift
//  MyCabin
//
//  Created by Lawless on 11/29/22.
//

import UIKit
import Combine

final class PlaneFactory {
    
    typealias ElementsDictionary = [String:[Codable]]
    //: State Handling
    ///Cabin Connection
    let cabinConnectionPublisher = CurrentValueSubject<Bool, Never>(false)
    
    let state: StateFactory
    
    //Used by loading view
    let cabinAPI: CabinAPI<EndpointFormats.Head, EmptyResponse>
    
    ///Access Levels
    let accessAPI = AccessAPI()
    ///Plane Map
    
    let elementsEndpoint = Endpoint<EndpointFormats.Get, ElementsEnum>(path: .elements)
    var elementFormatter: ElementDataFormatter
    
    let cacheUtil: FileCacheUtil
    
    init(state: StateFactory, cacheUtil: FileCacheUtil) {
        self.state = state
        
        let cabinEndpoint = Endpoint<EndpointFormats.Head, EmptyResponse>(path: .ping)
        self.cabinAPI = CabinAPI(endpoint: cabinEndpoint, publisher: cabinConnectionPublisher) { _ in }
        
        self.elementFormatter = ElementDataFormatter(state: state, cacheUtil: cacheUtil)
        
        self.cacheUtil = cacheUtil
    }
    
    //TODO: - does this need to be in here ?
    func connectToPlane() {
        
        Task(priority: .high) {
            do {
                try await self.cacheUtil.loadAllCaches()
            } catch {
                
                state.apiClient.fetch(for: elementsEndpoint) { res in
                    
                    let result = ElementsRoot(results: res, length: res.count)
                    
                    var dictionary = self.elementFormatter.mapResultsToDictionary(result: result)

                    self.elementFormatter.mapLightsToSeat(elements: &dictionary)

                    let sourceTypes = self.elementFormatter.findUniqueSourceTypes(elements: &dictionary)

                    self.state.planeMap = self.elementFormatter.buildPlaneMap(dictionary: dictionary, sourceSet: sourceTypes)

                    self.elementFormatter.mapElementsToPlaneAreas(allAreas: dictionary["allAreas"] as! [AreaModel], plane: &self.state.planeMap, elements: &dictionary)

                    self.elementFormatter.filterPlaneAreas(&self.state.planeMap)

                    Task {
                        await self.state.planeViewModel.updateValues(self.state.planeMap)
                    }

                    self.cacheUtil.updateAndCachePlaneElements(elements: dictionary)
                    self.cacheUtil.cacheToFile(data: self.state.planeMap)
                }
                //TODO: - Climate View troubleshoot
                state.apiClient.fetchClimateControllers(climateViewModel: state.climateViewModel, cacheUtil: cacheUtil)
            }
        }
    }
    
}


//final class StaticPlaneFactory {
//
//    typealias ElementsDictionary = [String:[Codable]]
//    //: State Handling
//    ///Cabin Connection
//    static let cabinConnectionPublisher = CurrentValueSubject<Bool, Never>(false)
//    static var cancelTokens = Set<AnyCancellable>()
//
//    //Used by loading view
//    static let cabinEndpoint = Endpoint<EndpointFormats.Head, EmptyResponse>(path: .ping)
//    static let cabinAPI = CabinAPI(endpoint: cabinEndpoint) { _ in }
//
//    ///Access Levels
//    static let accessAPI = AccessAPI()
//    ///Plane Map
//
//    static let elementsEndpoint = Endpoint<EndpointFormats.Get, ElementsEnum>(path: .elements)
//    static var elementFormatter = ElementDataFormatter()
//    static var planeMap  = PlaneMap()
//
//    //Plane Schematic View
//    static var planeViewModel = PlaneViewModel()
//
//    //TODO: move to view fac
//    static func buildPlaneSchematic(options: PlaneSchematicDisplayMode) -> PlaneSchematic {
//        let view = PlaneSchematic(planeViewModel: planeViewModel,
//                                  mediaViewModel: StateFactory.mediaViewModel,
//                                  planeDisplayOptionsBarBuilder: ViewFactory.buildPlaneDisplayOptionsBar,
//                                  planeFuselageBuilder: ViewFactory.buildPlaneFuselage)
//
//        Task { await planeViewModel.updateDisplayMode(options) }
//
//        return view
//    }
//
//    static func connectToPlane() {
//
//        Task(priority: .high) {
//            do {
//                try await FileCacheUtil.loadAllCaches()
//            } catch {
//
//                StateFactory.apiClient.fetch(for: elementsEndpoint) { res in
//
//                    let result = ElementsRoot(results: res, length: res.count)
//
//                    var dictionary = elementFormatter.mapResultsToDictionary(result: result)
//
//                    elementFormatter.mapLightsToSeat(elements: &dictionary)
//
//                    let sourceTypes = elementFormatter.findUniqueSourceTypes(elements: &dictionary)
//
//                    planeMap = elementFormatter.buildPlaneMap(dictionary: dictionary, sourceSet: sourceTypes)
//
//                    elementFormatter.mapElementsToPlaneAreas(allAreas: dictionary["allAreas"] as! [AreaModel], plane: &planeMap, elements: &dictionary)
//
//                    elementFormatter.filterPlaneAreas(&planeMap)
//
//                    Task {
//                        await planeViewModel.updateValues(planeMap)
//                    }
//
//                    FileCacheUtil.updateAndCachePlaneElements(elements: dictionary)
//                    FileCacheUtil.cacheToFile(data: planeMap)
//                }
//                //TODO: - Climate View troubleshoot
//                StateFactory.apiClient.fetchClimateControllers()
//            }
//        }
//    }
//
//}
