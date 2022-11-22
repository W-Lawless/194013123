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
        self.session = URLSession(configuration: customNetworkReqConfig)
    }

}

extension URLSession {
    func publisher<Format, ResponseModel>(
        for endpoint: Endpoint<Format, ResponseModel>,
        using requestData: Format.RequestData,
        decoder: JSONDecoder = .init()
    ) -> AnyPublisher<[ResponseModel], Error> {
        guard let request = endpoint.makeRequest(with: requestData) else {
            return Fail(error: InvalidEndpoint())
                .eraseToAnyPublisher()
        }

        return dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: NetworkResponse<ResponseModel>.self, decoder: decoder)
            .map(\.results)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
