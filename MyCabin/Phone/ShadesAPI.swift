//
//  ShadesAPI.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/17/22.
//

import Foundation
import Combine

extension GCMSClient {
    
    func commandShade(shade: ShadeModel, cmd: ShadeStates) {
        
        print(shade.id)
        
        let endpoint = Endpoint<EndpointFormats.Put<ShadeCommand>, EmptyResponse>(path: .shades, stateUpdate: shade.id)
        let encodeObj = ShadeCommand(cmd: cmd.rawValue)
        
        let publisher = Session.shared.publisherForNullResponse(for: endpoint, using: encodeObj)
        
        publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("there was an error", error)
                case .finished:
                    return
                }
            },
            receiveValue: { shade in
                    print("put request data", shade)
            }
        )
        .store(in: &self.cancelTokens)
    }
    
}

struct ShadeCommand: Codable {
    var cmd: String
}
