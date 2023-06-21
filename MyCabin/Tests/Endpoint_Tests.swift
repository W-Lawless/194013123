//
//  Endpoint_Tests.swift
//  Tests
//
//  Created by Lawless on 6/20/23.
//

import XCTest
@testable import MyCabin

final class Endpoint_Tests: XCTestCase {

    typealias StubbedEndpoint = Endpoint<EndpointFormats.Stub, String>
    let host = URLHost(rawValue: "10.0.0.41")
    
    func test_GeneratingRequestWithQueryItems() throws {
        let endpoint = StubbedEndpoint(path: .test, queryItems: [
            URLQueryItem(name: "a", value: "abc"),
            URLQueryItem(name: "b", value: "def")
        ])
        
        let request = endpoint.makeRequest(with: nil)
        
        try XCTAssertEqual(
            request?.url,
            host.expectedURL(withPath: "/api/v1/test?a=abc&b=def")
        )
    }
    
    //TODO: - Put Request , Head Request

    func test_PingEndpoint() throws {
        let endpoint = StubbedEndpoint(path: .ping)
        let request = endpoint.makeRequest(with: nil)
        XCTAssertEqual(request?.url, try? host.expectedURL(withPath: "/"))
    }
    
    func test_ElementsEndpoint() throws {
        let endpoint = StubbedEndpoint(path: .elements)
        let request = endpoint.makeRequest(with: nil)
        XCTAssertEqual(request?.url, try? host.expectedURL(withPath: "/api/v1/elements"))
    }
    
    func test_AccessEndpoint() throws {
        let endpoint = StubbedEndpoint(path: .access)
        let request = endpoint.makeRequest(with: nil)
        XCTAssertEqual(request?.url, try? host.expectedURL(withPath: "/api/v1/security/access-levels"))
    }
    
    func test_RegisterEndpoint() throws {
        let endpoint = StubbedEndpoint(path: .registerDevice)
        let request = endpoint.makeRequest(with: nil)
        XCTAssertEqual(request?.url, try? host.expectedURL(withPath: "/api/v1/security/clients"))
    }
    
    func test_LightsEndpoint() throws {
        let endpoint = StubbedEndpoint(path: .lights)
        let request = endpoint.makeRequest(with: nil)
        XCTAssertEqual(request?.url, try? host.expectedURL(withPath: "/api/v1/lights"))
    }
    
    func test_Stateful_LightsEndpoint() throws {
        let endpoint = StubbedEndpoint(path: .lights, stateUpdate: "light1")
        let request = endpoint.makeRequest(with: nil)
        XCTAssertEqual(request?.url, try? host.expectedURL(withPath: "/api/v1/lights/light1/state"))
    }
    
    func test_ShadesEndpoint() throws {
        let endpoint = StubbedEndpoint(path: .shades)
        let request = endpoint.makeRequest(with: nil)
        XCTAssertEqual(request?.url, try? host.expectedURL(withPath: "/api/v1/windows"))
    }
    
    func test_Stateful_ShadesEndpoint() throws {
        let endpoint = StubbedEndpoint(path: .shades, stateUpdate: "shade1")
        let request = endpoint.makeRequest(with: nil)
        XCTAssertEqual(request?.url, try? host.expectedURL(withPath: "/api/v1/windows/shade1/state"))
    }
    
    func test_SeatsEndpoint() throws {
        let endpoint = StubbedEndpoint(path: .seats)
        let request = endpoint.makeRequest(with: nil)
        XCTAssertEqual(request?.url, try? host.expectedURL(withPath: "/api/v1/seats"))
    }
    
    func test_ClimateEndpoint() throws {
        let endpoint = StubbedEndpoint(path: .climate)
        let request = endpoint.makeRequest(with: nil)
        XCTAssertEqual(request?.url, try? host.expectedURL(withPath: "/api/v1/tempcntrls"))
    }
    
    func test_MonitorsEndpoint() throws {
        let endpoint = StubbedEndpoint(path: .monitors)
        let request = endpoint.makeRequest(with: nil)
        XCTAssertEqual(request?.url, try? host.expectedURL(withPath: "/api/v1/monitors"))
    }
    
    func test_Stateful_MonitorsEndpoint() throws {
        let endpoint = StubbedEndpoint(path: .monitors, stateUpdate: "monitor1")
        let request = endpoint.makeRequest(with: nil)
        XCTAssertEqual(request?.url, try? host.expectedURL(withPath: "/api/v1/monitors/monitor1/state"))
    }
    
    func test_SpeakersEndpoint() throws {
        let endpoint = StubbedEndpoint(path: .speakers)
        let request = endpoint.makeRequest(with: nil)
        XCTAssertEqual(request?.url, try? host.expectedURL(withPath: "/api/v1/speakers"))
    }
    
    func test_Stateful_SpeakersEndpoint() throws {
        let endpoint = StubbedEndpoint(path: .speakers, stateUpdate: "speaker1")
        let request = endpoint.makeRequest(with: nil)
        XCTAssertEqual(request?.url, try? host.expectedURL(withPath: "/api/v1/speakers/speaker1/state"))
    }
    
    func test_SourcesEndpoint() throws {
        let endpoint = StubbedEndpoint(path: .sources)
        let request = endpoint.makeRequest(with: nil)
        XCTAssertEqual(request?.url, try? host.expectedURL(withPath: "/api/v1/sources"))
    }
    
    func test_FlightEndpoint() throws {
        let endpoint = StubbedEndpoint(path: .flightInfo)
        let request = endpoint.makeRequest(with: nil)
        XCTAssertEqual(request?.url, try? host.expectedURL(withPath: "/api/v1/flightInfo"))
    }
    
    func test_WeatherEndpoint() throws {
        let endpoint = StubbedEndpoint(path: .weather)
        let request = endpoint.makeRequest(with: nil)
        XCTAssertEqual(request?.url, try? host.expectedURL(withPath: "/api/v1/destination/weather"))
    }

}

extension URLHost {
    func expectedURL(withPath path: String) throws -> URL {
        let url = URL(string: "http://" + rawValue + path)
        return try XCTUnwrap(url)
    }
}
