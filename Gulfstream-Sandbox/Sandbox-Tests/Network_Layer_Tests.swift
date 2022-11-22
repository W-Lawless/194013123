//
//  Network_Layer_Tests.swift
//  Sandbox-Tests
//
//  Created by Lawless on 11/22/22.
//

//import XCTest
//
//final class Network_Layer_Tests: XCTestCase {
//
//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//
//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        // Any test you write for XCTest can be annotated as throws and async.
//        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
//        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
//    }
//
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
//
//}

//
//class Decoder_Tests: XCTestCase {
//
//    func testSeatDecoder() throws {
//        let pathString = Bundle(for: type(of: self)).path(forResource: "Seats", ofType: "json")!
//        let jsonString = try String(contentsOfFile: pathString, encoding: .utf8)
//        let jsonData = jsonString.data(using: .utf8)!
//
//        let _ = try! JSONDecoder().decode(NetworkResponse<SeatModel>.self, from: jsonData)
//    }
//
//    func testFlightDecoder() throws {
//        let pathString = Bundle(for: type(of: self)).path(forResource: "Flight", ofType: "json")!
//        let jsonString = try String(contentsOfFile: pathString, encoding: .utf8)
//        let jsonData = jsonString.data(using: .utf8)!
//
//        let _ = try! JSONDecoder().decode(NetworkResponse<FlightModel>.self, from: jsonData)
//    }
//
//    func testWeatherDecoder() throws {
//        let pathString = Bundle(for: type(of: self)).path(forResource: "Weather", ofType: "json")!
//        let jsonString = try String(contentsOfFile: pathString, encoding: .utf8)
//        let jsonData = jsonString.data(using: .utf8)!
//
//        let _ = try! JSONDecoder().decode(NetworkResponse<WeatherModel>.self, from: jsonData)
//    }
//
//}
