//
//  ClimateAPI.swift
//  MyCabin
//
//  Created by Lawless on 5/3/23.
//

import Foundation

extension GCMSClient {
    
    func fetchClimateControllers(climateViewModel: CabinClimateViewModel, cacheUtil: FileCacheUtil) {
        let endpoint = Endpoint<EndpointFormats.Get, ClimateControllerModel>(path: .climate)
        let callback: ([ClimateControllerModel]) -> Void = { controllers in
            climateViewModel.updateValues(controllers)
            cacheUtil.cacheToFile(data: controllers)
        }
        
        do {
            let cachedData = try cacheUtil.retrieveCachedFile(dataModel: [ClimateControllerModel].self)
            climateViewModel.updateValues(cachedData)
        } catch {
            self.fetch(for: endpoint, callback: callback)
        }
    }
    
}
