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
    static let cabinConnectionPublisher = CurrentValueSubject<Bool, Never>(false)
    static var cancelTokens = Set<AnyCancellable>()
    
    //Used by loading view
    static let cabinEndpoint = Endpoint<EndpointFormats.Head, EmptyResponse>(path: .ping)
    static let cabinAPI = CabinAPI(endpoint: cabinEndpoint) { _ in }
    
    ///Access Levels
    static let accessAPI = AccessAPI()
    ///Plane Map
    
    static let elementsEndpoint = Endpoint<EndpointFormats.Get, ElementsEnum>(path: .elements)
    static var elementFormatter = ElementDataFormatter()
    static var planeMap  = PlaneMap()
    
    //Plane Schematic View
    static var planeViewModel = PlaneViewModel()
    
    //TODO: move to view fac
    static func buildPlaneSchematic(options: PlaneSchematicDisplayMode) -> PlaneSchematic {
        let view = PlaneSchematic(planeViewModel: planeViewModel,
                                  mediaViewModel: StateFactory.mediaViewModel,
                                  planeDisplayOptionsBarBuilder: ViewFactory.buildPlaneDisplayOptionsBar,
                                  planeFuselageBuilder: ViewFactory.buildPlaneFuselage)
        
        Task { await planeViewModel.updateDisplayMode(options) }
        
        return view
    }
    
    static func connectToPlane() {
        
        Task(priority: .high) {
            do {
                try await FileCacheUtil.loadAllCaches()
            } catch {
                
                StateFactory.apiClient.fetch(for: elementsEndpoint) { res in
                    
                    let result = ElementsRoot(results: res, length: res.count)
                    
                    var dictionary = elementFormatter.mapResultsToDictionary(result: result)

                    elementFormatter.mapLightsToSeat(elements: &dictionary)

                    let sourceTypes = elementFormatter.findUniqueSourceTypes(elements: &dictionary)

                    planeMap = elementFormatter.buildPlaneMap(dictionary: dictionary, sourceSet: sourceTypes)

                    elementFormatter.mapElementsToPlaneAreas(allAreas: dictionary["allAreas"] as! [AreaModel], plane: &planeMap, elements: &dictionary)

                    elementFormatter.filterPlaneAreas(&planeMap)

                    Task {
                        await planeViewModel.updateValues(planeMap)
                    }

                    FileCacheUtil.updateAndCachePlaneElements(elements: dictionary)
                    FileCacheUtil.cacheToFile(data: planeMap)
                }
                //TODO: - Climate View troubleshoot
                StateFactory.apiClient.fetchClimateControllers()
            }
        }
    }
    
}
