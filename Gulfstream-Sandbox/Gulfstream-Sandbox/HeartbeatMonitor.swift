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


protocol HeartbeatMonitorTEST {
    associatedtype DataModel
//    typealias onPulse = (_ alive: Bool, _ data: DataModel?) async -> ()
    var onPulse: ((_ alive: Bool, _ data: DataModel?) async -> ())? { get set }
    func startMonitor(interval: Double)
    func stopMonitor()
    func findPulse() async
}



protocol HeartbeatMonitorTEST2{
//    var delegate: MonitorDelegate? { get set }
    func startMonitor(interval: Double, callback: (() async -> Void)?)
    func stopMonitor()
    var isTimerValid: Bool { get }
}

class HeartBeatMonitor {

    private var timer = Timer()
 
    var isTimerValid: Bool {
        return timer.isValid
    }
    
    func startMonitor(interval: Double, callback cb: (() async -> Void)?) {
        self.timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            print(" ⏱:: 🛩: \(interval)")
            Task(priority: .background) {
                await cb?()
            }
        }
    }
    
    func stopMonitor() {
        timer.invalidate()
    }

}
