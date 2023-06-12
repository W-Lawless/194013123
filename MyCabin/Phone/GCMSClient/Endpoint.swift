//
//  Endpoint.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/22/22.
//

import Foundation

enum GCMSEndpoints: String {
    
    case ping = "/"
    case elements = "/api/v1/elements"
    case access = "/api/v1/security/access-levels"
    case registerDevice = "/api/v1/security/clients"
    case lights = "/api/v1/lights"
    case shades = "/api/v1/windows"
    case seats = "/api/v1/seats"
    case climate = "/api/v1/tempcntrls"
    case monitors = "/api/v1/monitors"
    case speakers = "/api/v1/speakers"
    case sources = "/api/v1/sources"
    case flightInfo = "/api/v1/flightInfo"
    case weather = "/api/v1/destination/weather"
    
    func stateChange(_ id: String) -> String {
        switch self {
        case .lights:
            return "/api/v1/lights/\(id)/state"
        case .monitors:
            return "/api/v1/monitors/\(id)/state"
        case .shades:
            return "/api/v1/windows/\(id)/state"
        case .speakers:
            return "/api/v1/speakers/\(id)/state"
        default:
            return  "ENDPOINT NOT STATEFUL"
        }
    }
    
}


struct Endpoint<Format: EndpointFormat, ResponseModel: Codable> {
    var path: GCMSEndpoints
    var queryItems = [URLQueryItem]()
    var stateUpdate = ""
}


protocol EndpointFormat {
    associatedtype RequestData
    
    static func prepare(_ request: inout URLRequest,
                        with data: RequestData?)
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
    func makeRequest(with data: Format.RequestData?) -> URLRequest? {

        guard let url = validateUrl() else { return nil }
        var request = URLRequest(url: url)
        
        if let data {
            Format.prepare(&request, with: data)
        } else {
            Format.prepare(&request, with: nil)
        }

        return request
    }
    
    func validateUrl(host: URLHost = .default) -> URL? {
        var components = URLComponents()
        components.scheme = "http"
        components.host = host.rawValue
        
        if(self.stateUpdate != "") {
            components.path = self.path.stateChange(self.stateUpdate)
        } else {
            components.path = path.rawValue
        }
        
        components.queryItems = queryItems.isEmpty ? nil : queryItems

        guard let url = components.url else { return nil }
        return url
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
