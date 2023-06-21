//
//  Decoder_Tests.swift
//  Tests
//
//  Created by Lawless on 6/20/23.
//

import XCTest
@testable import MyCabin

final class Decoder_Tests: XCTestCase {
        
        func test_AreaDecoder() throws {
            let pathString = Bundle(for: type(of: self)).path(forResource: "Areas", ofType: "json")!
            let jsonString = try String(contentsOfFile: pathString, encoding: .utf8)
            let jsonData = jsonString.data(using: .utf8)!
            
            let _ = try! JSONDecoder().decode(NetworkResponse<AreaModel>.self, from: jsonData)
        }
        
        func test_AccessDecoder() throws {
            let pathString = Bundle(for: type(of: self)).path(forResource: "AccessLevels", ofType: "json")!
            let jsonString = try String(contentsOfFile: pathString, encoding: .utf8)
            let jsonData = jsonString.data(using: .utf8)!
            
            let _ = try! JSONDecoder().decode([AccessModel].self, from: jsonData)
        }
        
        func test_DeviceDecoder() throws {
            let pathString = Bundle(for: type(of: self)).path(forResource: "Devices", ofType: "json")!
            let jsonString = try String(contentsOfFile: pathString, encoding: .utf8)
            let jsonData = jsonString.data(using: .utf8)!

            let _ = try! JSONDecoder().decode([DeviceModel].self, from: jsonData)
        }
        
        func test_ClimateCtrlrDecoder() throws {
            let pathString = Bundle(for: type(of: self)).path(forResource: "Temperature", ofType: "json")!
            let jsonString = try String(contentsOfFile: pathString, encoding: .utf8)
            let jsonData = jsonString.data(using: .utf8)!

            let _ = try! JSONDecoder().decode(NetworkResponse<ClimateControllerModel>.self, from: jsonData)
        }
        
        
        func test_MonitorDecoder() throws {
            let pathString = Bundle(for: type(of: self)).path(forResource: "Monitors", ofType: "json")!
            let jsonString = try String(contentsOfFile: pathString, encoding: .utf8)
            let jsonData = jsonString.data(using: .utf8)!

            let _ = try! JSONDecoder().decode(NetworkResponse<MonitorModel>.self, from: jsonData)
        }
        
        func test_SourceDecoder() throws {
            let pathString = Bundle(for: type(of: self)).path(forResource: "Sources", ofType: "json")!
            let jsonString = try String(contentsOfFile: pathString, encoding: .utf8)
            let jsonData = jsonString.data(using: .utf8)!

            let _ = try! JSONDecoder().decode(NetworkResponse<SourceModel>.self, from: jsonData)
        }
        
        func test_SpeakerDecoder() throws {
            let pathString = Bundle(for: type(of: self)).path(forResource: "Speakers", ofType: "json")!
            let jsonString = try String(contentsOfFile: pathString, encoding: .utf8)
            let jsonData = jsonString.data(using: .utf8)!

            let _ = try! JSONDecoder().decode(NetworkResponse<SpeakerModel>.self, from: jsonData)
        }
        
        func test_LightsDecoder() throws {
            let pathString = Bundle(for: type(of: self)).path(forResource: "LightsData", ofType: "json")!
            let jsonString = try String(contentsOfFile: pathString, encoding: .utf8)
            let jsonData = jsonString.data(using: .utf8)!

            let _ = try! JSONDecoder().decode(NetworkResponse<LightModel>.self, from: jsonData)
        }
        
        func test_FlightDecoder() throws {
            let pathString = Bundle(for: type(of: self)).path(forResource: "Flight", ofType: "json")!
            let jsonString = try String(contentsOfFile: pathString, encoding: .utf8)
            let jsonData = jsonString.data(using: .utf8)!
            
            let _ = try! JSONDecoder().decode(NetworkResponse<FlightModel>.self, from: jsonData)
        }
        
        func test_SeatDecoder() throws {
            let pathString = Bundle(for: type(of: self)).path(forResource: "Seats", ofType: "json")!
            let jsonString = try String(contentsOfFile: pathString, encoding: .utf8)
            let jsonData = jsonString.data(using: .utf8)!

            let _ = try! JSONDecoder().decode(NetworkResponse<SeatModel>.self, from: jsonData)
        }

        func test_ShadesDecoder() throws {
            let pathString = Bundle(for: type(of: self)).path(forResource: "Shades", ofType: "json")!
            let jsonString = try String(contentsOfFile: pathString, encoding: .utf8)
            let jsonData = jsonString.data(using: .utf8)!

            let _ = try! JSONDecoder().decode(NetworkResponse<ShadeModel>.self, from: jsonData)
        }
        
        func test_WeatherDecoder() throws {
            let pathString = Bundle(for: type(of: self)).path(forResource: "Weather", ofType: "json")!
            let jsonString = try String(contentsOfFile: pathString, encoding: .utf8)
            let jsonData = jsonString.data(using: .utf8)!

            let _ = try! JSONDecoder().decode(NetworkResponse<WeatherModel>.self, from: jsonData)
        }
        
        func test_ElementsDecoder() throws {
            let pathString = Bundle(for: type(of: self)).path(forResource: "Elements", ofType: "json")!
            let jsonString = try String(contentsOfFile: pathString, encoding: .utf8)
            let jsonData = jsonString.data(using: .utf8)!

            let _ = try! JSONDecoder().decode(ElementsRoot.self, from: jsonData)
        }

}
