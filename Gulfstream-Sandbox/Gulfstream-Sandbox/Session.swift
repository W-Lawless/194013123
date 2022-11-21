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
    func publisher<K, R>(
        for endpoint: Endpoint<K, R>,
        using requestData: K.RequestData,
        decoder: JSONDecoder = .init()
    ) -> AnyPublisher<[R], Error> {
        guard let request = endpoint.makeRequest(with: requestData) else {
            return Fail(error: InvalidEndpoint())
                .eraseToAnyPublisher()
        }

        return dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: NetworkResponse<R>.self, decoder: decoder)
            .map(\.results)
            .eraseToAnyPublisher()
    }
}



struct Endpoint<Kind: EndpointKind, Response: Codable> {
    var path: String
    var queryItems = [URLQueryItem]()
}

protocol EndpointKind {
    associatedtype RequestData
    
    static func prepare(_ request: inout URLRequest,
                        with data: RequestData)
}

enum EndpointKinds {
    
    enum Head: EndpointKind {
        static func prepare(_ request: inout URLRequest,
                            with _: Void) {
            request.httpMethod = "HEAD"
        }
    }
    
    enum Get: EndpointKind {
        static func prepare(_ request: inout URLRequest,
                            with _: Void) {
            request.httpMethod = "GET"
        }
    }

    enum Put<Body>: EndpointKind {
        static func prepare(_ request: inout URLRequest, with data: Body) {
            request.httpMethod = "PUT"
            request.httpBody = data as? Data
        }
    }
}

extension Endpoint {
    func makeRequest(with data: Kind.RequestData) -> URLRequest? {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "10.0.0.41"
        components.path = path
        components.queryItems = queryItems.isEmpty ? nil : queryItems

        guard let url = components.url else { return nil }

        var request = URLRequest(url: url)
        Kind.prepare(&request, with: data)
        return request
    }
}

struct InvalidEndpoint: Error {
    let message = "Invalid Endpoint"
}
