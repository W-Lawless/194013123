//
//  CabinInterface.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/15/22.
//

import Foundation


class CabinAPI: ObservableObject {
    
    //MARK: - ViewModel
    
    @Published var pulse: Bool = false

    @MainActor func updateValues(_ alive: Bool, _ data: String?) -> Void {
        if (alive) {
            self.pulse = true
        } else {
            self.pulse = false
        }
    }
    
    var monitor = HeartBeatMonitor()

    //MARK: - API
    
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
    
    func monitorCallback() async {
        do {
            var request = URLRequest(url: self.endpoint, timeoutInterval: 5);
            request.httpMethod = "HEAD"
            let (_,response) = try await Session.shared.data(for: request)
            if let res = response as? HTTPURLResponse { print(" ✅: Cabin Responsed with Status:\(res.statusCode)")
                await updateValues(true, nil)
            }
        } catch {
            let cast = error as NSError;
            print(" ❌: Cabin Connection Error \(cast.code)")
            await updateValues(false, nil)
        }
    }
    
}

