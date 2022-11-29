//
//  +Cabin.swift
//  wearable Watch App
//
//  Created by Lawless on 11/15/22.
//

import Foundation

class CabinHeartbeat: ObservableObject {

    @Published var pulse: Bool = false
    @Published var loading: Bool = true
    private var urlRequest: URLRequest?
    private var timer: Timer?

    init() {
        var request = URLRequest(url: URL(string:"http://10.0.0.41")!, timeoutInterval: 8.0); request.httpMethod = "HEAD"
        self.urlRequest = request
    }

    func startMonitor(interval: Double) {
        print("listening \(interval)")
        DispatchQueue.global(qos: .background).async {
            self.timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
                self.findHearbeat()
            }
            RunLoop.current.add(self.timer!, forMode: .common);
            RunLoop.current.run()
        }
    }
    
    func stopMonitor() {
        DispatchQueue.global(qos: .background).async {
            self.timer?.invalidate()
        }
    }

    func findHearbeat() {
        let task = Session.shared.dataTask(with: self.urlRequest!) { data, response, error in
            guard error == nil else { let cast = error! as NSError; print(" ❌: Connection Error \(cast.code)")
                self.connectionHeartbeat(alive: false); return
            }
            if let res = response as? HTTPURLResponse { print(" ✅: Host Responsed with Status:\(res.statusCode)")
                self.connectionHeartbeat(alive: true)
            }
        }
        task.resume()
    }

    func connectionHeartbeat(alive: Bool) {
        if (alive) { DispatchQueue.main.async {
                self.loading = false
                self.pulse = true
            }
        } else { DispatchQueue.main.async {
                self.loading = true
                self.pulse = false
            }
        }
    }
}

