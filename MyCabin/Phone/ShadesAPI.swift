//
//  ShadesAPI.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/17/22.
//

import Foundation
import Combine

class ShadesAPI {
    
    let viewModel: ShadesViewModel
    var cancelToken: Cancellable?

    let endpoint = Endpoint<EndpointFormats.Get, ShadeModel>(path: "/api/v1/windows")
    
    init(viewModel: ShadesViewModel) {
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
            receiveValue: { shades in
                self.viewModel.updateValues(true, shades)
//                print("shades")
//                PersistenceUtil.cacheToFile(data: shades)
            }
        ) 
    }
    
    func commandShade(shade: ShadeModel, cmd: ShadeStates) {
        
        let endpoint = Endpoint<EndpointFormats.Put<ShadeCommand>, EmptyResponse>(path: "/api/v1/windows/\(shade.id)/state")
        let encodeObj = ShadeCommand(cmd: cmd.rawValue)
        
        let publisher = Session.shared.publisherForNullResponse(for: endpoint, using: encodeObj)
        
        self.cancelToken = publisher.sink(
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
    }
    
}


struct ShadeCommand: Codable {
    var cmd: String
}

enum ShadeStates: String {
    case OPEN
    case CLOSE
    case SHEER
}

struct ShadeModel: Codable, Identifiable {
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
