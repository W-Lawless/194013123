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

class CabinMonitor: HeartbeatMonitor {
    
    private var endpoint: URLRequest?
    private var timer: Timer?
    var onPulse: (_ alive: Bool, _ data: String?) async -> ()

    init(endpoint url: URL, callBack cb: @escaping (_ alive: Bool, _ data: String?) async -> ()) {
        var request = URLRequest(url: url, timeoutInterval: 5);
        request.httpMethod = "HEAD" ///Reduces size of packet transfer
        self.endpoint = request
        self.onPulse = cb
    }

    func startMonitor(interval: Double) {
        print("Start Monitor w/ \(interval)")
        DispatchQueue.global(qos: .background).async {
            self.timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
                Task {
                    print("Interval is \(interval)")
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
            if let res = response as? HTTPURLResponse { print(" ✅: Cabin Responsed with Status:\(res.statusCode)")
                await self.onPulse(true, nil)
            }
        } catch {
            let cast = error as NSError;
            print(" ❌: Cabin Connection Error \(cast.code)")
            await self.onPulse(false, nil)
        }
    }
}



