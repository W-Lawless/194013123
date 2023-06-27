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
    var valuePublisher: CurrentValueSubject<Bool, Never>?
    
    init(endpoint: Endpoint<F ,R>, publisher: CurrentValueSubject<Bool, Never>? = nil, callback: @escaping ([R]) -> Void) {
        self.endpoint = endpoint
        self.callback = callback
        self.valuePublisher = publisher
    }
    
    func listen() {
        if let valuePublisher = self.valuePublisher {
            self.ping(for: endpoint) { response in
                if (response.statusCode == 200) {
                    valuePublisher.send(true)
                } else {
                    valuePublisher.send(false)
                }
            }
        }
    }
    
}

