//
//  Sandbox_Tests.swift
//  Sandbox-Tests
//
//  Created by Lawless on 11/17/22.
//

import XCTest
@testable import Gulfstream_Sandbox


class Monitor_Tests: XCTestCase {
    
    func testMonitorStarts() throws {

        let monitor = HeartBeatMonitor()
    ()

        let timerStarts = expectation(description: "timerStarts")
        func testTimer() async -> Void {
            timerStarts.fulfill()
            XCTAssertTrue(monitor.isTimerValid)
            monitor.stopMonitor()
        }

        monitor.startMonitor(interval: 1.1, callback: testTimer)

        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testMonitorStops() throws {
        let monitor = HeartBeatMonitor()

        let timerStops = expectation(description: "timerStops")
        func testTimer() async -> Void {
            monitor.stopMonitor()
            timerStops.fulfill()
            XCTAssertFalse(monitor.isTimerValid)
        }

        monitor.startMonitor(interval: 1.2, callback: testTimer)

        waitForExpectations(timeout: 2, handler: nil)
    }
        
}



class TestDecoders: XCTestCase {
    
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

class TestViewFactories: XCTestCase {
    
    func testFactories() throws {
        XCTAssert(type(of: ViewFactories.buildFlightInfo()) == FlightInfo.self)
        XCTAssert(type(of: ViewFactories.buildSeatsSelection()) == SeatSelection.self)
    }
    
}

/*
class TimerControllerTests: XCTestCase {

    // MARK: - Properties

    var timerController: TimerController!

    // MARK: - Setup

    override func setUp() {
        timerController = TimerController(seconds: 1)
    }

    // MARK: - Teardown

    override func tearDown() {
        timerController.resetTimer()
        super.tearDown()
    }

    // MARK: - Time

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

    // MARK: - Timer State

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


//class NetworkIntegrationTests: XCTestCase {
//    func testSuccessfullyPerformingRequest() throws {
//        let session = URLSession(mockResponder: Item.MockDataURLResponder.self)
//        let accessToken = AccessToken(rawValue: "12345")
//
//        let publisher = session.publisher(for: .latestItem, using: accessToken)
//        let result = try awaitCompletion(of: publisher)
//
//        XCTAssertEqual(result, [Item.MockDataURLResponder.item])
//    }
//}


/*
class Monitor_Tests: XCTestCase {
    
    var monitor: CabinMonitorTEST!

    override func setUp() {
        let endpoint = URL(string: "http://apple.com")!
        self.monitor = CabinMonitorTEST(endpoint: endpoint, callBack: nil)
    }

    override func tearDown() {
        monitor.stopMonitor()
        super.tearDown()
    }
    
    
    func testMonitorStarts() throws {
        
        let timerStarts = expectation(description: "timerStarts")
        func tickClock(_ alive: Bool, _: String?) async -> () {
            timerStarts.fulfill()
            XCTAssertTrue(monitor.isTimerValid)
        }
    
        self.monitor.onPulse = tickClock
        self.monitor.startMonitor(interval: 1)
     
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testMonitorStops() throws {

        let timerStops = expectation(description: "timerStops")

        func tickClock(_ alive: Bool, _: String?) async -> () {
            self.monitor.stopMonitor()
            timerStops.fulfill()
            XCTAssertFalse(monitor.isTimerValid)
        }

        self.monitor.onPulse = tickClock
        monitor.startMonitor(interval: 1)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
}
*/
