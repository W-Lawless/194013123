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
                    print("Success")
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
                    print("Put request made")
                    return
                }
            },
            receiveValue: { shade in
                    print("put request data", shade)
            }
        )
    }
    
}

enum LightState {
    var rawValue: Bool {
        return self == .ON ? true : false
    }
    
    case ON
    case OFF
}

struct LightModel: Codable, Identifiable {
    var id: String
    var name: String
    struct rect: Codable {
        var x: Float
        var y: Float
        var w: Float
        var h: Float
        var r: Int
    }
    var side: String
    var sub: [String?]
    struct assoc: Codable {
        var id: String
    }
    var type: String
    struct color: Codable {
        var color_type: String
        var palettes: [String]?
    }
    struct brightness: Codable {
        var dimmable: Bool
        var range: [Int]
    }
    struct icons: Codable {
        var on: String
        var off: String
    }
    struct state: Codable {
        var on: Bool
        var brightness: Int
    }
}



