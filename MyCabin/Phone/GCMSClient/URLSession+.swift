//
//  SessionConfig.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/10/22.
//

import Foundation
import Combine

struct Session {
    
    let session: URLSession
    
    static var shared: URLSession  {
        get {
            return Session().session
        }
    }

    private init() {
        let customNetworkReqConfig = URLSessionConfiguration.ephemeral
        customNetworkReqConfig.timeoutIntervalForRequest = 29
        customNetworkReqConfig.timeoutIntervalForResource = 29
        customNetworkReqConfig.urlCache = nil
        self.session = URLSession(configuration: customNetworkReqConfig)
    }
    
    //TODO: Long, Short session timeout instance

}

extension URLSession {
    func publisher<Format, ResponseModel>(
        for endpoint: Endpoint<Format, ResponseModel>,
        using requestData: Format.RequestData?,
        decoder: JSONDecoder = .init(),
        array: Bool = false,
        null: Bool = false
    ) -> AnyPublisher<[ResponseModel], Error> {
        
        guard endpoint.validateUrl() != nil else { return Fail(error: InvalidEndpoint()).eraseToAnyPublisher() }
        guard let request = endpoint.makeRequest(with: requestData ?? nil) else { return Fail(error: InvalidEndpoint()).eraseToAnyPublisher() }
        print("Fething @", request.url)
        
        return dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: NetworkResponse<ResponseModel>.self, decoder: decoder)
            .map(\.results)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func publisherForNullResponse<Format, ResponseModel>( for endpoint: Endpoint<Format, ResponseModel>,
        using requestData: Format.RequestData? = nil, decoder: JSONDecoder = .init() ) -> AnyPublisher<EmptyResponse, Error> {
        
        guard let request = endpoint.makeRequest(with: requestData) else {
            return Fail(error: InvalidEndpoint())
                .eraseToAnyPublisher()
        }

        return dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: EmptyResponse.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func publisherForArrayResponse<Format, ResponseModel>( for endpoint: Endpoint<Format, ResponseModel>,
        using requestData: Format.RequestData, decoder: JSONDecoder = .init() ) -> AnyPublisher<[ResponseModel], Error> {
        
        guard let request = endpoint.makeRequest(with: requestData) else {
            return Fail(error: InvalidEndpoint())
                .eraseToAnyPublisher()
        }

        return dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: [ResponseModel].self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func publisherForPinging<Format, ResponseModel>( for endpoint: Endpoint<Format, ResponseModel>, decoder: JSONDecoder = .init() ) -> AnyPublisher<HTTPURLResponse, Error> {
        
        guard let request = endpoint.makeRequest(with: nil) else {
            return Fail(error: InvalidEndpoint())
                .eraseToAnyPublisher()
        }

        return dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse else {
                    throw HTTPError.statusCode
                }
                return response
            }
            .eraseToAnyPublisher()
    }
}

enum HTTPError: LocalizedError {
    case statusCode
}
