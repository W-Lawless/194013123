//
//  ShadesAPI.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/17/22.
//

import Foundation

struct ShadesAPI {
    
    func fetchEndpoint() {
        let url = URL(string: "https://api.github.com/repos/johnsundell/publish")!
        let publisher = URLSession.shared.dataTaskPublisher(for: url)
        
        let cancellable = publisher.sink(
            receiveCompletion: { completion in
                // Called once, when the publisher was completed.
                print(completion)
            },
            receiveValue: { value in
                // Can be called multiple times, each time that a
                // new value was emitted by the publisher.
                print(value)
            }
        )
    }
}
