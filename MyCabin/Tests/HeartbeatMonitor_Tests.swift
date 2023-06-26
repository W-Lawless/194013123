//
//  HeartbeatMonitor_Tests.swift
//  Tests
//
//  Created by Lawless on 6/20/23.
//

import XCTest
@testable import MyCabin

final class HeartbeatMonitor_Tests: XCTestCase {

    func test_MonitorStarts() throws {

        let monitor = HeartBeatMonitor()

        let timerStarts = expectation(description: "timerStarts")
        func testTimer() async -> Void {
            timerStarts.fulfill()
            XCTAssertTrue(monitor.isTimerValid)
            monitor.stopMonitor()
        }

        monitor.startMonitor(interval: 0.1, callback: testTimer)

        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_MonitorStops() throws {
        let monitor = HeartBeatMonitor()

        let timerStops = expectation(description: "timerStops")
        func testTimer() async -> Void {
            monitor.stopMonitor()
            timerStops.fulfill()
            XCTAssertFalse(monitor.isTimerValid)
        }

        monitor.startMonitor(interval: 0.1, callback: testTimer)

        waitForExpectations(timeout: 1, handler: nil)
    }

}
