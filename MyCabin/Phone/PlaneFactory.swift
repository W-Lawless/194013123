//
//  LoadAll.swift
//  MyCabin
//
//  Created by Lawless on 11/29/22.
//

import UIKit
import Combine


final class PlaneFactory {
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
    static var planeViewModel = PlaneViewModel()
    
    static var elementsAPI = ElementsAPI(viewModel: planeViewModel)
    
    static var planeMap  = PlaneMap()
    
    //Menus
    
    static func buildPlaneSchematic(options: PlaneSchematicDisplayMode) -> PlaneSchematic {
        let view = PlaneSchematic(viewModel: planeViewModel, options: options)
        return view
    }
    
    static func connectToPlane() {
        Task(priority: .high) {
//            do {
//                try await FileCacheUtil.loadAllCaches()
//            } catch {
//                print("Cache failed to load")
                await PlaneFactory.elementsAPI.fetch()
//            }
//            StateFactory.apiClient.fetchClimateControllers()
        }
    }
    
    static func seatIconCallback(displayOptions: PlaneSchematicDisplayMode, seatID: String) {
        switch displayOptions {
        case .onlySeats:
            UserDefaults.standard.set(seatID, forKey: "CurrentSeat")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                NavigationFactory.homeMenuCoordinator.dismiss()
            }
        case .showLights:
            UserDefaults.standard.set(seatID, forKey: "CurrentSeat")
            StateFactory.lightsViewModel.showSubView(forID: seatID)
        default:
            break
        } //: SWITCH
    }
    
    static func buildPlaneSchematicPreview(options: PlaneSchematicDisplayMode) -> PlaneSchematic {
        let file = Bundle.main.url(forResource: "planeMap", withExtension: "json")
        let jsonData = try? Data(contentsOf: file!)
        let planeMap = try? JSONDecoder().decode(PlaneMap.self, from: jsonData!)
        let vm = PlaneViewModel()
        vm.plane = planeMap!
        let view = PlaneSchematic(viewModel: vm, options: options)
        return view
    }
    
}
