//
//  CabinInterface.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/15/22.
//

import Foundation
import Combine

class CabinAPI<F: EndpointFormat, R: Codable>: GCMSClient, Realtime_API {
    
    var monitor = HeartBeatMonitor()
    
    var endpoint: Endpoint<F, R>
    var callback: ([R]) -> Void 
    
    init(endpoint: Endpoint<F ,R>, callback: @escaping ([R]) -> Void) {
        self.endpoint = endpoint
        self.callback = callback
    }
    
    func listen() {
        self.ping(for: endpoint) { response in
            if (response.statusCode == 200) {
                PlaneFactory.cabinConnectionPublisher.send(true)
            } else {
                PlaneFactory.cabinConnectionPublisher.send(false)
            }
        }
    }
    
}

