//
//  CabinInterface.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/15/22.
//

import Foundation

class CabinAPI: ObservableObject {
    
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
    
    var monitor: (any HeartbeatMonitor)?
    
    static var shared: CabinAPI {
        get {
            let foo = CabinAPI()
            foo.monitor = CabinMonitor(endpoint: foo.endpoint, callBack: foo.updateValues)
            return foo
        }
    }
    private init() { }
    
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
        DispatchQueue.global(qos: .background).async {
            self.timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
                Task {
                    print(" ⏱: \(interval)")
                    await self.findPulse()
                }
            }
            RunLoop.current.add(self.timer!, forMode: .default);
            RunLoop.current.run()
        }
    }
    
    func stopMonitor() {
        DispatchQueue.global(qos: .background).async {
            self.timer?.invalidate()
        }
    }
    
    func findPulse() async {
        do {
            let (_,response) = try await Session.shared.data(for: self.endpoint!)
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



