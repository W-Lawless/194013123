//
//  Endpoint.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/22/22.
//

import Foundation

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

    enum Put<Body: Codable>: EndpointFormat {
        static func prepare(_ request: inout URLRequest, with data: Body?) {
//            print("preparing put request", data, type(of: data))
            request.httpMethod = "PUT"
            if let data {
                let requestBody = try! JSONEncoder().encode(data)
                request.httpBody = requestBody
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            }
//            print("** ", requestBody)
        }
    }
    
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
