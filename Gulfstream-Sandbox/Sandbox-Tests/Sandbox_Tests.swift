//
//  Sandbox_Tests.swift
//  Sandbox-Tests
//
//  Created by Lawless on 11/17/22.
//

import XCTest
@testable import Gulfstream_Sandbox

final class Sandbox_Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFactories() throws {
        XCTAssert(type(of: ViewFactories.buildFlightInfo()) == FlightInfo.self)
        XCTAssert(type(of: ViewFactories.buildSeatsSelection()) == SeatSelection.self)
    }
    
    func testSeatDecoder() throws {
        let pathString = Bundle(for: type(of: self)).path(forResource: "Seats", ofType: "json")!
        let jsonString = try String(contentsOfFile: pathString, encoding: .utf8)
        let jsonData = jsonString.data(using: .utf8)!
        
        let _ = try! JSONDecoder().decode(SeatsModel.self, from: jsonData)
    }
    
    func testFlightDecoder() throws {
        let pathString = Bundle(for: type(of: self)).path(forResource: "Flight", ofType: "json")!
        let jsonString = try String(contentsOfFile: pathString, encoding: .utf8)
        let jsonData = jsonString.data(using: .utf8)!
        
        let _ = try! JSONDecoder().decode(FlightModel.self, from: jsonData)
    }
    
    func testWeatherDecoder() throws {
        let pathString = Bundle(for: type(of: self)).path(forResource: "Weather", ofType: "json")!
        let jsonString = try String(contentsOfFile: pathString, encoding: .utf8)
        let jsonData = jsonString.data(using: .utf8)!
        
        let _ = try! JSONDecoder().decode(WeatherModel.self, from: jsonData)
    }
    
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
