//
//  AccessAPI.swift
//  MyCabin
//
//  Created by Lawless on 12/1/22.
//

import Foundation
import Combine

class AccessAPI {
    
    var cancelToken: Cancellable?

    let endpoint = Endpoint<EndpointFormats.Get, AccessModel>(path: "/api/v1/security/access-levels")
    
    func fetch() {
        let publisher = Session.shared.publisherForArrayResponse(for: endpoint, using: nil)
        
        self.cancelToken = publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    return
                }
            },
            receiveValue: { levels in
//                levels.forEach{ level in
//                    print(level.id, terminator: "\n")
//                }
//                CacheUtil.store("Lights", data: lights)
//                PersistenceUtil.cacheToFile(data: lights)
            }
        )
    }
    
//    func toggleLight(_ light: LightModel, cmd: LightState) {
//
//        let endpoint = Endpoint<EndpointFormats.Put<LightModel.state>, LightModel.state>(path: "/api/v1/lights/\(light.id)/state")
//        let encodeObj = LightModel.state(on: cmd.rawValue, brightness: cmd.rawValue == true ? 100 : 0)
//
//        let publisher = Session.shared.publisher(for: endpoint, using: encodeObj)
//
//        self.cancelToken = publisher.sink(
//            receiveCompletion: { completion in
//                switch completion {
//                case .failure(let error):
//                    print("there was an error", error)
//                case .finished:
//                    return
//                }
//            },
//            receiveValue: { lightState in
//                    print("put request data", lightState)
//            }
//        )
//    }
    
}
