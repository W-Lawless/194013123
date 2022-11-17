//
//  MockSession.swift
//  Sandbox-Tests
//
//  Created by Lawless on 11/17/22.
//

import Foundation
import XCTest
import Combine

struct MockSession {
    
    let session: URLSession
    
    static var shared: URLSession  {
        get {
            return MockSession().session
        }
    }

    private init() {
        let customNetworkReqConfig = URLSessionConfiguration.ephemeral
        customNetworkReqConfig.timeoutIntervalForRequest = 29
        customNetworkReqConfig.timeoutIntervalForResource = 29
        self.session = URLSession(configuration: customNetworkReqConfig)
    }
}

//MARK: - Session Config

extension URLSession {

    convenience init<T: MockURLResponder>(mockResponder: T.Type) {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol<T>.self]
        self.init(configuration: config)
        URLProtocol.registerClass(MockURLProtocol<T>.self)
    }
    
}

//extension URLSession {
//    func publisher<K, R>(
//        for endpoint: Endpoint<K, R>,
//        using requestData: K.RequestData,
//        decoder: JSONDecoder = .init()
//    ) -> AnyPublisher<R, Error> {
//        guard let request = endpoint.makeRequest(with: requestData) else {
//            return Fail(
//                error: InvalidEndpointError(endpoint: endpoint)
//            ).eraseToAnyPublisher()
//        }
//
//        return dataTaskPublisher(for: request)
//            .map(\.data)
//            .decode(type: NetworkResponse<R>.self, decoder: decoder)
//            .map(\.result)
//            .eraseToAnyPublisher()
//    }
//}

class MockURLProtocol<Responder: MockURLResponder>: URLProtocol {
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        guard let client = client else { return }

        do {
            // Here we try to get data from our responder type, and
            // we then send that data, as well as a HTTP response,
            // to our client. If any of those operations fail,
            // we send an error instead:
            let data = try Responder.respond(to: request)
            let response = try XCTUnwrap(HTTPURLResponse(
                url: XCTUnwrap(request.url),
                statusCode: 200,
                httpVersion: "HTTP/1.1",
                headerFields: nil
            ))

            client.urlProtocol(self,
                didReceive: response,
                cacheStoragePolicy: .notAllowed
            )
            client.urlProtocol(self, didLoad: data)
        } catch {
            client.urlProtocol(self, didFailWithError: error)
        }

        client.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {
        // Required method, implement as a no-op.
    }
}


protocol MockURLResponder {
    static func respond(to request: URLRequest) throws -> Data
}


struct Item: Decodable {
    var title: String
    var description: String
}

//extension Item {
//    enum MockDataURLResponder: MockURLResponder {
//        static let item = Item(title: "Title", description: "Description")
//
//        static func respond(to request: URLRequest) throws -> Data {
//            let response = NetworkResponse(result: item)
//            return try JSONEncoder().encode(response)
//        }
//    }
//}

struct NetworkResponse<Wrapped: Decodable>: Decodable {
    var result: Wrapped
}
