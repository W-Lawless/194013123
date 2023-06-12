//
//  GeneralAPI.swift
//  MyCabin
//
//  Created by Lawless on 11/29/22.
//

import Foundation
import Combine

protocol GCMS_API: AnyObject {
    var cancelTokens: Set<AnyCancellable> { get set }
    
    func put<F, R>(for endpoint: Endpoint<F, R>, putData: F.RequestData, callback: @escaping ([R]) -> Void)
    func fetch<F, R>(for endpoint: Endpoint<F, R>, callback: @escaping ([R]) -> Void)
    func ping<F, R>(for endpoint: Endpoint<F, R>, callback: @escaping (HTTPURLResponse) -> Void)
}


class GCMSClient: GCMS_API, ObservableObject {
    @Published var cancelTokens = Set<AnyCancellable>()
}


extension GCMS_API {
    func put<F: EndpointFormat,ResponseType: Codable>(for endpoint: Endpoint<F,ResponseType>, putData: F.RequestData, callback: @escaping ([ResponseType]) -> Void) {

        let publisher = Session.shared.publisher(for: endpoint, using: putData)

        publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("API CONNECTION ERROR: \(error.localizedDescription)")
                    callback([ResponseType]())
                case .finished:
                    return
                }
            },
            receiveValue: { data in
                callback(data)
            }
        )
        .store(in: &cancelTokens)
    }
    
    func fetch<F: EndpointFormat,ResponseType: Codable>(for endpoint: Endpoint<F,ResponseType>, callback: @escaping ([ResponseType]) -> Void) {
        let publisher = Session.shared.publisher(for: endpoint, using: nil)
        
        publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("API CONNECTION ERROR: \(error.localizedDescription)")
                    callback([ResponseType]())
                case .finished:
                    print("API SUBSCRIPTION CLOSED")
                    return
                }
            },
            receiveValue: { result in
                callback(result)
            }
        )
        .store(in: &cancelTokens)
    }
    
    func ping<F: EndpointFormat,ResponseType: Codable>(for endpoint: Endpoint<F,ResponseType>, callback: @escaping (HTTPURLResponse) -> Void) {
        let publisher = Session.shared.publisherForPinging(for: endpoint)
        
        publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("API CONNECTION ERROR: \(error.localizedDescription)")
                    callback(HTTPURLResponse(url: URL(string: "gulf.aero.cabin")!, statusCode: 404, httpVersion: nil, headerFields: nil)!)
                case .finished:
                    print("API SUBSCRIPTION CLOSED")
                    return
                }
            },
            receiveValue: { result in
                callback(result)
            }
        )
        .store(in: &cancelTokens)
    }
    
}
