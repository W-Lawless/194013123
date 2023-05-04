//
//  RealtimeAPI.swift
//  MyCabin
//
//  Created by Lawless on 5/3/23.
//

import Foundation

protocol Realtime_API: GCMS_API {
    associatedtype F: EndpointFormat
    associatedtype R: Codable
    
    var endpoint: Endpoint<F, R> { get set }
    var callback: ([R]) -> Void { get set }
    var monitor: HeartBeatMonitor { get }
    func listen()
    func monitorCallback()
}

class RealtimeAPI<F: EndpointFormat ,R: Codable>: GCMSClient, Realtime_API {
    
    let monitor = HeartBeatMonitor()
    
    var endpoint: Endpoint<F, R>
    var callback: ([R]) -> Void
    
    init(endpoint: Endpoint<F ,R>, callback: @escaping ([R]) -> Void) {
        self.endpoint = endpoint
        self.callback = callback
    }
}

extension Realtime_API {
    func listen() {
        self.fetch(for: self.endpoint, callback: self.callback)
    }
    
    func monitorCallback() {
        listen()
    }
}

