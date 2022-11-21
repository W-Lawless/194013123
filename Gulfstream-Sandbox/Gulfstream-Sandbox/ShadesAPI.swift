//
//  ShadesAPI.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/17/22.
//

import Foundation

struct ShadesAPI {
    
    func fetchEndpoint() {
        let url = URL(string: "http://10.0.0.41/api/v1/windows")!
        let publisher = URLSession.shared.dataTaskPublisher(for: url)
        
        let cancellable = publisher.sink(
            receiveCompletion: { completion in
                // Called once, when the publisher was completed.
                print(completion)
            },
            receiveValue: { value in
                // Can be called multiple times, each time that a
                // new value was emitted by the publisher.
                
                let decoder = JSONDecoder()
                
                do {
                    let repo = try decoder.decode(NetworkResponse<ShadesModel>.self, from: value.data)
                } catch {
                    print(error)
                }
                
                
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
