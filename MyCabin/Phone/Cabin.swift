//
//  CabinInterface.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/15/22.
//

import Foundation
import Combine


class CabinAPI: ObservableObject {
    
    //MARK: - ViewModel
    
    @Published var loading: Bool = true
    @Published var pulse: Bool = false

    @MainActor func updateValues(_ alive: Bool, _ data: String?) -> Void {
        self.loading = false
        if (alive) {
            self.pulse = true
        } else {
            self.pulse = false
        }
    }
    
    var monitor = HeartBeatMonitor()

    //MARK: - API
    
    var statePublisher: CurrentValueSubject<Bool, Never>
    
    init(publisher p: CurrentValueSubject<Bool, Never>) {
        self.statePublisher = p
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
    
    func monitorCallback() async {
        do {
            var request = URLRequest(url: self.endpoint, timeoutInterval: 5);
            request.httpMethod = "HEAD"
            let (_,response) = try await Session.shared.data(for: request)
            if response is HTTPURLResponse { //print(" ✅: Cabin Responsed with Status:\(res.statusCode)")
//                await updateValues(true, nil)
                self.statePublisher.send(true)
            }
        } catch {
//            let cast = error as NSError;
//            print(" ❌: Cabin Connection Error \(cast.code)")
//            await updateValues(false, nil)
            self.statePublisher.send(false)
        }
    }
    
}

