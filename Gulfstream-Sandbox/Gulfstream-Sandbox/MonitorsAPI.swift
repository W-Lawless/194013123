//
//  MonitorsAPI.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/28/22.
//

import Combine

class MonitorsAPI {
    
    let viewModel: MonitorsViewModel
    var cancelToken: Cancellable?

    let endpoint = Endpoint<EndpointFormats.Get, MonitorModel>(path: "/api/v1/monitors")
    
    init(viewModel: MonitorsViewModel) {
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
            receiveValue: { monitors in
                self.viewModel.updateValues(true, monitors)
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

