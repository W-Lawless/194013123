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
            .eraseToAnyPublisher()
    }
}

//MARK: - Endpoint Generation

struct Endpoint<Format: EndpointFormat, ResponseModel: Codable> {
    var path: String
    var queryItems = [URLQueryItem]()
}


protocol EndpointFormat {
    associatedtype RequestData
    
    static func prepare(_ request: inout URLRequest,
                        with data: RequestData)
}

enum EndpointFormats {
    
    enum Head: EndpointFormat {
        static func prepare(_ request: inout URLRequest,
                            with _: Void?) {
            request.httpMethod = "HEAD"
        }
    }
    
    enum Get: EndpointFormat {
        static func prepare(_ request: inout URLRequest,
                            with _: Void?) {
            request.httpMethod = "GET"
        }
    }

//    enum Put<Body>: EndpointFormat {
//        static func prepare(_ request: inout URLRequest, with data: Body) {
//            request.httpMethod = "PUT"
//            request.httpBody = data as? Data
//        }
//    }
    
    enum Stub: EndpointFormat {
        static func prepare(_ request: inout URLRequest, with data: Void?) {
            /// For Tests
        }
    }
    
}


extension Endpoint {
    func makeRequest(with data: Format.RequestData, host: URLHost = .default) -> URLRequest? {
        var components = URLComponents()
        components.scheme = "http"
        components.host = host.rawValue
        components.path = path
        components.queryItems = queryItems.isEmpty ? nil : queryItems

        guard let url = components.url else { return nil }

        var request = URLRequest(url: url)
        Format.prepare(&request, with: data)
        return request
    }
}

//MARK: - Host Configuration

struct URLHost: RawRepresentable {
    var rawValue: String
}

extension URLHost {
    static var staging: Self {
        URLHost(rawValue: "10.0.0.41")
    }

    static var production: Self {
        URLHost(rawValue: "ProductionServerString")
    }

    static var `default`: Self {
        #if DEBUG
        return staging
        #else
        return production
        #endif
    }
}


//MARK: - Util

struct InvalidEndpoint: Error {
    let message = "Invalid Endpoint"
}
