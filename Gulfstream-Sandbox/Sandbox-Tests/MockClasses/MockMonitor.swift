//
//  MockMonitor.swift
//  Sandbox-Tests
//
//  Created by Lawless on 11/17/22.
//

import Foundation

protocol HeartbeatMonitor {
    associatedtype DataModel
    var onPulse: (_ alive: Bool, _ data: DataModel?) async -> () { get set }
    func startMonitor(interval: Double)
    func stopMonitor()
    func findPulse() async
}

class MockMonitor: HeartbeatMonitor {
    
    private var endpoint: URLRequest?
    private var timer: Timer?
    var timerProvider: Timer.Type
    var onPulse: (_ alive: Bool, _ data: String?) async -> ()

    init(endpoint url: URL, callBack cb: @escaping (_ alive: Bool, _ data: String?) async -> (), timerProvider: Timer.Type = Timer.self) {
        var request = URLRequest(url: url, timeoutInterval: 0.2);
        request.httpMethod = "GET" ///Reduces size of packet transfer
        self.endpoint = request
        self.onPulse = cb
        self.timerProvider = timerProvider
    }

    func startMonitor(interval: Double) {
        DispatchQueue.global(qos: .background).async {
            self.timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
                Task {
                    await self.findPulse()
                }
            }
            RunLoop.current.add(self.timer!, forMode: .default);
            RunLoop.current.run()
        }
    }
    
    func stopMonitor() {
        print("Monitor killed")
        DispatchQueue.global(qos: .background).async {
            self.timer?.invalidate()
        }
    }
    
    func findPulse() async {
        do {
            let (_,response) = try await MockSession.shared.data(for: self.endpoint!)
            if let res = response as? HTTPURLResponse {
                print(" ✅ ")
                await self.onPulse(true, nil)
            }
        } catch {
            print(" ❌ ")
            let cast = error as NSError;
            await self.onPulse(false, nil)
        }
    }
}



