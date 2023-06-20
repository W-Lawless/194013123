//
//  HeartbeatMonitor.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/15/22.
//

import Foundation

class HeartBeatMonitor {

    private var timer = Timer()
    private var interval = 0.0
 
    var isTimerValid: Bool {
        return timer.isValid
    }
    
    var currentInterval: Double {
        return self.interval
    }
    
    func startMonitor(interval: Double, callback cb: @escaping () async -> Void) { /// print(" ⏱ 🏁: \(interval)")
        self.interval = interval
        self.timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in /// print(" ⏱: \(interval)")
            Task(priority: .background) {
                await cb()
            }
        }
    }
    
    func stopMonitor() { /// print(" ⏱ ❌ ")
        timer.invalidate()
    }
}
