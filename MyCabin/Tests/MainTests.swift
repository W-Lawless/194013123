//
//  Sandbox_Tests.swift
//  Sandbox-Tests
//
//  Created by Lawless on 11/17/22.
//

import XCTest
import Combine
@testable import MyCabin
import SwiftUI


//MARK: - UI Layer

class ViewFactory_Tests: XCTestCase {
    
    /// API & View must always share same ViewModel instance
    
    func testFlightInfoFactory() throws {
        let testView = AppFactory.buildFlightInfo()
        XCTAssertTrue(testView.api.viewModel === testView.viewModel)
    }
    
    func testSeatSelection() throws {
        let testView = AppFactory.buildSeatSelection()
        XCTAssertTrue(testView.api.viewModel === testView.viewModel)
    }
    
}

class Navigation_Tests: XCTestCase {
    
    func testMenuRouter() throws {
        let coordinator = AppFactory.buildHomeMenu()
        let targetView = MenuRouter.lights.view()

        coordinator.navigationController.pushViewController(targetView, animated: false)
        
        let visible = coordinator.navigationController.visibleViewController
        
        XCTAssertTrue(visible === targetView)
    }
    
}

// MARK: - Network Layer

class Monitor_Tests: XCTestCase {
    
    func testMonitorStarts() throws {

        let monitor = HeartBeatMonitor()

        let timerStarts = expectation(description: "timerStarts")
        func testTimer() async -> Void {
            timerStarts.fulfill()
            XCTAssertTrue(monitor.isTimerValid)
            monitor.stopMonitor()
        }

        monitor.startMonitor(interval: 1, callback: testTimer)

        waitForExpectations(timeout: 1.1, handler: nil)
    }
    
    func testMonitorStops() throws {
        let monitor = HeartBeatMonitor()

        let timerStops = expectation(description: "timerStops")
        func testTimer() async -> Void {
            monitor.stopMonitor()
            timerStops.fulfill()
            XCTAssertFalse(monitor.isTimerValid)
        }

        monitor.startMonitor(interval: 1, callback: testTimer)

        waitForExpectations(timeout: 1.1, handler: nil)
    }
        
}

class Endpoint_Tests: XCTestCase {
    
    typealias StubbedEndpoint = Endpoint<EndpointFormats.Stub, String>
    let host = URLHost(rawValue: "10.0.0.41")
    
    func testBasicRequestGeneration() throws {
        let endpoint = StubbedEndpoint(path: "/path/v1/resource")
        let request = endpoint.makeRequest(with: nil)
        XCTAssertEqual(request?.url, try? host.expectedURL(withPath: "/path/v1/resource"))
    }
    
    func testGeneratingRequestWithQueryItems() throws {
           let endpoint = StubbedEndpoint(path: "/path", queryItems: [
               URLQueryItem(name: "a", value: "1"),
               URLQueryItem(name: "b", value: "2")
           ])

           let request = endpoint.makeRequest(with: nil)

           try XCTAssertEqual(
               request?.url,
               host.expectedURL(withPath: "/path?a=1&b=2")
           )
       }
    
    func testFlightAPIEndpoint() throws {
        let endpoint = StubbedEndpoint(path: "/api/v1/flightInfo")
        let request = endpoint.makeRequest(with: nil)
        XCTAssertEqual(request?.url, try? host.expectedURL(withPath: "/api/v1/flightInfo"))
    }
    
    func testSeatsAPIEndpoint() throws {
        let endpoint = StubbedEndpoint(path: "/api/v1/seats")
        let request = endpoint.makeRequest(with: nil)
        XCTAssertEqual(request?.url, try? host.expectedURL(withPath: "/api/v1/seats"))
    }
    
}

class Decoder_Tests: XCTestCase {
    
    func testAreaDecoder() throws {
        let pathString = Bundle(for: type(of: self)).path(forResource: "Areas", ofType: "json")!
        let jsonString = try String(contentsOfFile: pathString, encoding: .utf8)
        let jsonData = jsonString.data(using: .utf8)!
        
        let _ = try! JSONDecoder().decode(NetworkResponse<AreaModel>.self, from: jsonData)
    }

    func testSeatDecoder() throws {
        let pathString = Bundle(for: type(of: self)).path(forResource: "Seats", ofType: "json")!
        let jsonString = try String(contentsOfFile: pathString, encoding: .utf8)
        let jsonData = jsonString.data(using: .utf8)!

        let _ = try! JSONDecoder().decode(NetworkResponse<SeatModel>.self, from: jsonData)
    }

    func testFlightDecoder() throws {
        let pathString = Bundle(for: type(of: self)).path(forResource: "Flight", ofType: "json")!
        let jsonString = try String(contentsOfFile: pathString, encoding: .utf8)
        let jsonData = jsonString.data(using: .utf8)!

        let _ = try! JSONDecoder().decode(NetworkResponse<FlightModel>.self, from: jsonData)
    }

    func testWeatherDecoder() throws {
        let pathString = Bundle(for: type(of: self)).path(forResource: "Weather", ofType: "json")!
        let jsonString = try String(contentsOfFile: pathString, encoding: .utf8)
        let jsonData = jsonString.data(using: .utf8)!

        let _ = try! JSONDecoder().decode(NetworkResponse<WeatherModel>.self, from: jsonData)
    }

}

class NetworkIntegration_Test: XCTestCase {
    
    typealias StubbedEndpoint = Endpoint<EndpointFormats.Stub, FlightModel>
    let host = URLHost(rawValue: "test.url.com")
    let endpoint = StubbedEndpoint(path: "/api/v1/testEndpoint")
    
    func testSuccessfullyPerformingRequest() throws {
        
        let session = URLSession(mockResponder: FlightModel.MockDataURLResponder.self)

        let publisher = session.publisher(for: endpoint, using: nil)
        let result = try awaitCompletion(of: publisher)[0]
        
        XCTAssertEqual(result[0], FlightModel.MockDataURLResponder.dummyModel)
    }
}

class ConcurrencyTimeBenchmark_Tests: XCTestCase {
    
    func testBulkFetch() throws {
        measure {
            AppFactory.fetchAll()
        }
    }
    
}

class Network_Tests: XCTestCase {
    
//    func test_init_doesNotRequestData() {
//        let spy = SessionSpy()
//        XCTAssertTrue(spy.messages.isEmpty)
//    }
//    
////    func test_
//    
//    func test_returnsErrorOnBadURL() {
//        let endpoint = Endpoint<EndpointFormats.Get, LightModel>(path: "^#@&^@")
//        let publisher = Session.shared.publisher(for: endpoint, using: nil)
//        
//        let exp = expectation(description: "Wait for completion")
//        let cancelToken = publisher.sink(
//            receiveCompletion: { completion in
//                switch completion {
//                case .failure(let error as InvalidEndpoint):
//                    XCTAssertEqual(error.message, "Invalid Endpoint")
//                    exp.fulfill()
//                default:
//                    return
//                }
//            },
//            receiveValue: { _ in }
//        )
//        
//        
//        wait(for: [exp], timeout: 1.0)
//    }
    
    
    
}

//MARK: - Network Test Infrastructure

//private class SessionSpy: URLSession {
//    var messages = [(path: String, request: URLRequest)]()
//
//    func get(from path: String, request: URLRequest){
//        messages.append((path, request))
//    }
//
////    func complete(with error: Error, at index: Int = 0){
////        messages[index].completion(Result.failure(error))
////    }
////
////    func complete(withStatusCode code: Int, data: Data, at index: Int = 0){
////        let response = HTTPURLResponse(url: requestedURLs[index], statusCode: code, httpVersion: nil, headerFields: nil)!
////        messages[index].completion(Result.success())
////    }
//    
//    func spyPublisher<Format, ResponseModel>(
//        for endpoint: Endpoint<Format, ResponseModel>,
//        using requestData: Format.RequestData,
//        decoder: JSONDecoder = .init()
//    ) -> Result<Any, Error> {
//        
//        
//        guard let request = endpoint.makeRequest(with: requestData) else {
//            return Result.failure(InvalidEndpoint())
//        }
//        messages.append((path: endpoint.path, request: request))
//        
////        return dataTaskPublisher(for: request)
////            .map(\.data)
////            .decode(type: NetworkResponse<ResponseModel>.self, decoder: decoder)
////            .map(\.results)
////            .receive(on: DispatchQueue.main)
////            .eraseToAnyPublisher()
////        return Result
//    }
//}


extension URLHost {
    func expectedURL(withPath path: String) throws -> URL {
        let url = URL(string: "http://" + rawValue + path)
        return try XCTUnwrap(url)
    }
}

protocol MockURLResponder {
    static func respond(to request: URLRequest) throws -> Data
}

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

extension URLSession {
    convenience init<T: MockURLResponder>(mockResponder: T.Type) {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol<T>.self]
        self.init(configuration: config)
        URLProtocol.registerClass(MockURLProtocol<T>.self)
    }
}

extension FlightModel {
    struct MockDataURLResponder: MockURLResponder {
        static let dummyModel = FlightModel(latitude: 0.0, longitude: 0.0, altitude: 0, air_speed: 0, ground_speed: 0, estimated_arrival: 0, destination_timezone: "UTC", time_remaining: 0, current_time: 0, total_time: 0, external_temperature: 0, forward_cabin_temp: 0, aft_cabin_temp: 0, on_ground: true, mach: 0.0, mode: true)

        static func respond(to request: URLRequest) throws -> Data {
            let response = NetworkResponse(results: [dummyModel], length: 1)
            return try JSONEncoder().encode(response)
        }
    }
}

extension XCTestCase {
    func awaitCompletion<T: Publisher>(
        of publisher: T,
        timeout: TimeInterval = 10
    ) throws -> [T.Output] {
        // An expectation lets us await the result of an asynchronous
        // operation in a synchronous manner:
        let expectation = self.expectation(
            description: "Awaiting publisher completion"
        )

        var completion: Subscribers.Completion<T.Failure>?
        var output = [T.Output]()

        let cancellable = publisher.sink {
            completion = $0
            expectation.fulfill()
        } receiveValue: {
            output.append($0)
        }

        // Our test execution will stop at this point until our
        // expectation has been fulfilled, or until the given timeout
        // interval has elapsed:
        waitForExpectations(timeout: timeout)

        switch completion {
        case .failure(let error):
            throw error
        case .finished:
            return output
        case nil:
            // If we enter this code path, then our test has
            // already been marked as failing, since our
            // expectation was never fullfilled.
            cancellable.cancel()
            return []
        }
    }
}


/*
 /// This was a very hard to find example of thorough testing of the Timer class, please leave for future reference
class TimerControllerTests: XCTestCase {

    // MARK - Properties

    var timerController: TimerController!

    // MARK - Setup

    override func setUp() {
        timerController = TimerController(seconds: 1)
    }

    // MARK - Teardown

    override func tearDown() {
        timerController.resetTimer()
        super.tearDown()
    }

    // MARK - Time

    func test_TimerController_DurationInSeconds_IsSet() {
        let expected: TimeInterval = 60
        let timerController = TimerController(seconds: 60)
        XCTAssertEqual(timerController.durationInSeconds, expected, "'durationInSeconds' is not set to correct value.")
    }

    func test_TimerController_DurationInSeconds_IsZeroAfterTimerIsFinished() {
        let numberOfSeconds: TimeInterval = 1
        let durationExpectation = expectation(description: "durationExpectation")
        timerController = TimerController(seconds: numberOfSeconds)
        timerController.startTimer(fireCompletion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + numberOfSeconds, execute: {
            durationExpectation.fulfill()
            XCTAssertEqual(0, self.timerController.durationInSeconds, "'durationInSeconds' is not set to correct value.")
        })
        waitForExpectations(timeout: numberOfSeconds + 1, handler: nil)
    }

    // MARK - Timer State

    func test_TimerController_TimerIsValidAfterTimerStarts() {
        let timerValidityExpectation = expectation(description: "timerValidity")
        timerController.startTimer {
            timerValidityExpectation.fulfill()
            XCTAssertTrue(self.timerController.isTimerValid, "Timer is invalid.")
        }
        waitForExpectations(timeout: 5, handler: nil)
    }

    func test_TimerController_TimerIsInvalidAfterTimerIsPaused() {
        let timerValidityExpectation = expectation(description: "timerValidity")
        timerController.startTimer {
            self.timerController.pauseTimer()
            timerValidityExpectation.fulfill()
            XCTAssertFalse(self.timerController.isTimerValid, "Timer is valid")
        }
        waitForExpectations(timeout: 5, handler: nil)
    }

    func test_TimerController_TimerIsInvalidAfterTimerIsReset() {
        let timerValidityExpectation = expectation(description: "timerValidity")
        timerController.startTimer {
            self.timerController.resetTimer()
            timerValidityExpectation.fulfill()
            XCTAssertFalse(self.timerController.isTimerValid, "Timer is valid")
        }
        waitForExpectations(timeout: 5, handler: nil)
    }

}
*/
