//
//  CabinInterface.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/15/22.
//

import Foundation
import Combine

class CabinAPI: ObservableObject {

    var monitor = HeartBeatMonitor()
    
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
            if response is HTTPURLResponse { ///print(" ✅: Cabin Responsed with Status:\(res.statusCode)")
                AppFactory.cabinConnectionPublisher.send(true)
            }
        } catch {
            /// let cast = error as NSError; print(" ❌: Cabin Connection Error \(cast.code)")
            AppFactory.cabinConnectionPublisher.send(false)
        }
    }
    
}

