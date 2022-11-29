//
//  LightsAPI.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/23/22.
//

import Foundation
import Combine

class LightsAPI {
    
    let viewModel: LightsViewModel
    var cancelToken: Cancellable?

    let endpoint = Endpoint<EndpointFormats.Get, LightModel>(path: "/api/v1/lights")
    
    init(viewModel: LightsViewModel) {
        self.viewModel = viewModel
    }
    
    func fetch() {
        let publisher = Session.shared.publisher(for: endpoint, using: nil)
        
        self.cancelToken = publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    return
                }
            },
            receiveValue: { lights in
                self.viewModel.updateValues(true, lights)
            }
        )
    }
    
    func toggleLight(_ light: LightModel, cmd: LightState) {
        
        let endpoint = Endpoint<EndpointFormats.Put<LightModel.state>, LightModel.state>(path: "/api/v1/lights/\(light.id)/state")
        let encodeObj = LightModel.state(on: cmd.rawValue, brightness: cmd.rawValue == true ? 100 : 0)
                
        let publisher = Session.shared.publisher(for: endpoint, using: encodeObj)
        
        self.cancelToken = publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("there was an error", error)
                case .finished:
                    return
                }
            },
            receiveValue: { light in
                    print("put request data", light)
            }
        )
    }
    
}
