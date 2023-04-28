//
//  GeneralAPI.swift
//  MyCabin
//
//  Created by Lawless on 11/29/22.
//

import Foundation
import Combine

protocol GCMS_API {
    associatedtype F: EndpointFormat
    associatedtype R: Codable
    
    typealias ApiEndpoint = Endpoint<F, R>
    typealias ApiPutData = F.RequestData
    
    var endpoint: ApiEndpoint { get set }
    var viewModel: GCMSViewModel { get set }
    var cancelTokens: Set<AnyCancellable> { get set }
    
    mutating func put(for endpoint: ApiEndpoint, viewModel: GCMSViewModel, putData: ApiPutData)
    mutating func fetch(for endpoint: ApiEndpoint, viewModel: GCMSViewModel, completion: @escaping ([R]) -> Void)
}

protocol GCMSViewModel {
    func updateValues(_ data: [Codable])
}


extension GCMS_API {
    mutating func put<F: EndpointFormat,ResponseType: Codable>(for endpoint: Endpoint<F,ResponseType>, viewModel: GCMSViewModel, putData: F.RequestData) {

        let publisher = Session.shared.publisher(for: endpoint, using: putData)

        publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    return
                }
            },
            receiveValue: { data in
                print("received data")
                viewModel.updateValues(data)
            }
        )
        .store(in: &cancelTokens)

    }
    
    mutating func fetch<F: EndpointFormat,ResponseType: Codable>(for endpoint: Endpoint<F,ResponseType>, viewModel: GCMSViewModel, completion: @escaping ([ResponseType]) -> Void) {
        let publisher = Session.shared.publisher(for: endpoint, using: nil)
        
        publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    return
                }
            },
            receiveValue: { result in
                completion(result)
            }
        )
        .store(in: &cancelTokens)
    }
    
}

class TestGeneral<F: EndpointFormat ,R: Codable>: GCMS_API {
    var viewModel: GCMSViewModel
    var endpoint:  Endpoint<F, R>
    var cancelTokens = Set<AnyCancellable>()
    
    init(endpoint: Endpoint<F ,R>, viewModel: GCMSViewModel) {
        self.endpoint = endpoint
        self.viewModel = viewModel
    }
}
