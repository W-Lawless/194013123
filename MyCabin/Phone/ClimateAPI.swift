//
//  ClimateAPI.swift
//  MyCabin
//
//  Created by Lawless on 5/3/23.
//

import Foundation

extension GCMSClient {
    
    func fetchClimateControllers() {
        let endpoint = Endpoint<EndpointFormats.Get, ClimateControllerModel>(path: .climate)
        let callback: ([ClimateControllerModel]) -> Void = { controllers in
            print("LOOKUP CLIMATE CONTROLLERS")
            StateFactory.climateViewModel.updateValues(controllers)
            FileCacheUtil.cacheToFile(data: controllers)
        }
        
        do {
            let cachedData = try FileCacheUtil.retrieveCachedFile(dataModel: [ClimateControllerModel].self)
            StateFactory.climateViewModel.updateValues(cachedData)
        } catch {
            self.fetch(for: endpoint, callback: callback)
        }
    }
    
}
