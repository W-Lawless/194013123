//
//  NetworkingTests.swift
//  Tests
//
//  Created by Lawless on 4/22/23.
//

import XCTest
import Combine
@testable import MyCabin

final class NetworkingTests: XCTestCase {

    var cancelTokens = Set<AnyCancellable>()
    var session: URLSession?
    
    override func setUp() {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolStub.self]
        self.session = URLSession(configuration:  config)
    }
    
    //MARK: - URLSession Extension
    
    func test_URLSessionPublisher_failsOnRequestError() {
        let requestError = NSError(domain: "NSURLErrorDomain", code: -1)
        let receivedError = resultErrorFor(data: nil, response: nil, error: requestError) as NSError?

        if let receivedError {
            XCTAssertEqual(receivedError.domain, requestError.domain)
            XCTAssertEqual(receivedError.code, requestError.code)
        }
    }
    
    func test_URLSessionPublisher_failsOnAllInvalidCases() {
        XCTAssertNotNil(resultErrorFor(data: nil, response: nil, error: nil), "No error received")
        XCTAssertNotNil(resultErrorFor(data: nil, response: nonHTTPURLResponse(), error: nil))
        XCTAssertNotNil(resultErrorFor(data: nil, response: nonHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: nil, response: anyHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: nil, error: nil))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: nil, error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: nonHTTPURLResponse(), error: nil))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: nonHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: anyHTTPURLResponse(), error: anyNSError()))
    }
    
    func test_URLSessionPublisher_succeedsWithExpectedData() {
        let response = anyHTTPURLResponse()
        
        let testBundle = Bundle(for: type(of: self))
        let file = testBundle.url(forResource: "LightsData", withExtension: "json")!
        
         let json = try? Data(contentsOf: file)
        let receivedValues = resultValuesFor(data: json, response: response, error: nil)
        
        let decoder = try? JSONDecoder().decode(NetworkResponse<LightModel>.self, from: json!)
        let target = decoder?.results
        
        XCTAssertEqual(receivedValues, target, "Expected \(String(describing: target)), got \(String(describing: receivedValues)) instead")
       
    }
    
    //MARK: - General API Abstraction
    
    func test_GeneralAPI_FetchesAndUpdatesViewModel() {
        let exp = expectation(description: "Wait for completion")
        
        let endpoint = Endpoint<EndpointFormats.Get, LightModel>(path: "/api/v1/lights")
        let viewModel = LightsViewModel()

        let sut = TestGeneral(endpoint: endpoint, viewModel: viewModel)
        sut.fetch(for: sut.endpoint, viewModel: viewModel) { result in
            viewModel.updateValues(result)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5.0)

        XCTAssertTrue(type(of: viewModel.lightList?.first?.brightness) == LightBrightness?.self, "Did not find \(String(describing: viewModel.lightList?.first?.brightness))")

    }

    //MARK: - Utils
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> URLSession {
        let sut = self.session
        return sut!
    }
    
    func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }
    
    private func anyData() -> Data {
        return Data("any data".utf8)
    }
    
    
    private func anyHTTPURLResponse() -> HTTPURLResponse {
        return HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
    }
    
    private func nonHTTPURLResponse() -> URLResponse {
        return URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
    }
    
    func anyURL() -> URL {
        return URL(string: "http://any-url.com")!
    }
    
    
    private func resultErrorFor(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #file, line: UInt = #line) -> Error? {
        URLProtocolStub.stub(data: data, response: response, error: error)

        let sut = makeSUT(file: file, line: line)
        let exp = expectation(description: "Wait for completion")

        var receivedError: Error?
        let endpoint = Endpoint<EndpointFormats.Get, LightModel>(path: "/api/v1/lights")

        let publisher = sut.publisher(for: endpoint, using: nil)
        
        publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    exp.fulfill()
                    receivedError = error
                case .finished:
                    exp.fulfill()
                    return
                }
            },
            receiveValue: { result in
                exp.fulfill()
                XCTFail("Expected failure with error \(String(describing: error)), got \(result) instead", file: file, line: line)
            }
        )
        .store(in: &self.cancelTokens)

        
        wait(for: [exp], timeout: 1.0)
        return receivedError
    }
    
    private func resultValuesFor(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #file, line: UInt = #line) -> [LightModel]? {
        URLProtocolStub.stub(data: data, response: response, error: error)
        
        let sut = makeSUT(file: file, line: line)
        let exp = expectation(description: "Wait for completion")

        var receivedValues: [LightModel]?
        
        let endpoint = Endpoint<EndpointFormats.Get, LightModel>(path: "/api/v1/lights")

        let publisher = sut.publisher(for: endpoint, using: nil)
        
        publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    exp.fulfill()
                    XCTFail("Expected success, got \(error) instead", file: file, line: line)
                case .finished:
                    return
                } 
            },
            receiveValue: { result in
                exp.fulfill()
                receivedValues = result
            }
        )
        .store(in: &self.cancelTokens)

        
        wait(for: [exp], timeout: 1.0)
        return receivedValues
    }
    
    //MARK: - Test Stubs
    
    private class URLProtocolStub: URLProtocol {
        
        private static var stub: Stub?
        private static var requestObserver: ((URLRequest) -> Void)?
        
        private struct Stub {
            let data: Data?
            let response: URLResponse?
            let error: Error?
        }
        
        static func stub(data: Data?, response: URLResponse?, error: Error?) {
            stub = Stub(data: data, response: response, error: error)
        }
        
        static func observeRequests(observer: @escaping (URLRequest) -> Void) {
            requestObserver = observer
        }
        
        static func startInterceptingRequests(){
            URLProtocol.registerClass(URLProtocolStub.self)
        }
        
        static func stopInterceptingRequests() {
            URLProtocol.unregisterClass(URLProtocolStub.self)
            stub = nil
            requestObserver = nil
        }
        
        override class func canInit(with request: URLRequest) -> Bool {
            requestObserver?(request)
            return true
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }
        
        override func startLoading() {
            
            if let data = URLProtocolStub.stub?.data {
                client?.urlProtocol(self, didLoad: data)
            }
            
            if let response = URLProtocolStub.stub?.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            if let error = URLProtocolStub.stub?.error {
                client?.urlProtocol(self, didFailWithError: error)
            }
            
            client?.urlProtocolDidFinishLoading(self)
        }
        
        override func stopLoading() {
            
        }
    }

}
