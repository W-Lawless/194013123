//
//  Seats.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/10/22.
//

import Foundation
import Combine

extension GCMSClient {
    
    func call(seat: SeatModel) {
        
        let endpoint = Endpoint<EndpointFormats.Put<SeatModel.state>, SeatModel.state>(path: .seats, stateUpdate: seat.id)
        let encodeObj = SeatModel.state(call: true, identifier: seat.id)
        
        let publisher = Session.shared.publisher(for: endpoint, using: encodeObj)
        
        publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    print("Put request made")
                    return
                }
            },
            receiveValue: { seats in
                    print("put request data", seats)
            }
        )
        .store(in: &self.cancelTokens)
    }
    
}
