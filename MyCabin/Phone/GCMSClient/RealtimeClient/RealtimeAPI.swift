//
//  RealtimeAPI.swift
//  MyCabin
//
//  Created by Lawless on 5/3/23.
//

import Combine

protocol Realtime_API: GCMS_API {
    associatedtype F: EndpointFormat
    associatedtype R: Codable
    
    var monitor: HeartBeatMonitor { get }
    var endpoint: Endpoint<F, R> { get set }
    var callback: ([R]) -> Void { get set }
    var valuePublisher: CurrentValueSubject<Bool, Never>? { get set }
    func listen()
    func monitorCallback()
}

class RealtimeAPI<F: EndpointFormat ,R: Codable>: GCMSClient, Realtime_API {
    
    
    let monitor = HeartBeatMonitor()
    
    var endpoint: Endpoint<F, R>
    var callback: ([R]) -> Void
    
    var valuePublisher: CurrentValueSubject<Bool, Never>?
    
    init(endpoint: Endpoint<F ,R>, publisher: CurrentValueSubject<Bool, Never>? = nil, callback: @escaping ([R]) -> Void) {
        self.endpoint = endpoint
        self.callback = callback
        if let publisher {
            self.valuePublisher = publisher
        }
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

