//
//  ShadesAPI.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/17/22.
//

import Foundation
import Combine

class ShadesAPI {
    
    var cancelToken: Cancellable?
    
    func fetchEndpoint() {
        print("fetch")
        
        let endpoint = Endpoint<EndpointFormats.Get, ShadesModel>(path: "/api/v1/windows")
        
        let publisher = Session.shared.publisher(for: endpoint, using: nil)
        
        self.cancelToken = publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    print("Success")
                }
            },
            receiveValue: { shades in
                print(shades)
            }
        )
        
        
        
    }
}

struct ShadesModel: Codable {
    var id: String
    var name: String
    var side: String
    var sub: [String?]
    var assoc: [String?]
    struct capabilities: Codable {
        var position: Bool
        var fabricCount: Int
        var shadeCommands: [String]
    }
}
