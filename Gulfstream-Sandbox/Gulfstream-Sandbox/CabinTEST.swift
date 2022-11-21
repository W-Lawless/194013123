//
//  CabinInterface.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/15/22.
//

import Foundation

class CabinAPITEST: ObservableObject {
    
    @Published var pulse: Bool = false

    @MainActor func updateValues(_ alive: Bool, _ data: String?) {
        if (alive) {
            self.pulse = true
        } else {
            self.pulse = false
        }
    }
    
    private let scheme = "http"
    private let host = "10.0.0.41"
    private let baseApi = "/"
    private var endpoint: URL {
        var URI = URLComponents()
        URI.scheme = self.scheme
        URI.host = self.host
        URI.path = "\(self.baseApi)"
        return URI.url!
    }
    
    var monitor: (any HeartbeatMonitorTEST)?
    
    static var shared: CabinAPITEST {
        get {
            let foo = CabinAPITEST()
            foo.monitor = CabinMonitorTEST(endpoint: foo.endpoint, callBack: foo.updateValues)
            return foo
        }
    }
    private init() { }
    
}

class CabinMonitorTEST: HeartbeatMonitorTEST {
 
    typealias callBack = (_ alive: Bool, _ data: String?) async -> ()
    
    private var endpoint: URLRequest?
    private var timer = Timer()
    
    internal var onPulse: callBack?
    var isTimerValid: Bool {
        return timer.isValid
    }
    
    init(endpoint url: URL, callBack cb: callBack?) {
        var request = URLRequest(url: url, timeoutInterval: 5);
        request.httpMethod = "HEAD"
        self.endpoint = request
        self.onPulse = cb
    }

    func startMonitor(interval: Double) {
        self.timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [unowned self] _ in
            Task { await onPulse?(false, nil) } 
            //            Task {
//                print(" ⏱: \(interval)")
//                await findPulse()
//            }
        }
    }
    
    func stopMonitor() {
        timer.invalidate()
    }
    
    func findPulse() async {
        do {
            let (_,response) = try await Session.shared.data(for: self.endpoint!)
            if let res = response as? HTTPURLResponse { print(" ✅: Cabin Responsed with Status:\(res.statusCode)")
                await self.onPulse?(true, nil)
            }
        } catch {
            let cast = error as NSError;
            print(" ❌: Cabin Connection Error \(cast.code)")
            await self.onPulse?(false, nil)
        }
    }
}



