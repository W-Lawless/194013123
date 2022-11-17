//
//  HeartbeatMonitor.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/15/22.
//

import Foundation

protocol HeartbeatMonitor {
    associatedtype DataModel
    var onPulse: (_ alive: Bool, _ data: DataModel?) async -> () { get set }
    func startMonitor(interval: Double)
    func stopMonitor()
    func findPulse() async
}
