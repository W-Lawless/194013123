//
//  LightsSubMenu_Tests.swift
//  Tests
//
//  Created by Lawless on 6/20/23.
//

import XCTest
@testable import MyCabin

final class LightsSubMenu_Tests: XCTestCase {

    func test_UpdateLights() {
        let sut = makeSUT()
        let mockData = [LightModel(), LightModel()]
        sut.updateLights(mockData)
        
        XCTAssertEqual(sut.lightList, mockData)
    }
    
    func test_UpdateSeats() {
        let sut = makeSUT()
        let mockData = [SeatModel(), SeatModel()]
        sut.updateSeats(mockData)
        
        XCTAssertEqual(sut.allSeats, mockData)
    }
    
    func test_GetLightsForSeat() {
        let sut = makeSUT()
        sut.activeSeat = "seat1"
        let mockData = [SeatModel(id: "seat1", lights: [LightModel(id: "light1")])]
        sut.updateSeats(mockData)
        sut.getLightsForSeat()
        
        XCTAssertEqual(sut.lightsForSeat[0], mockData[0].lights![0])
    }
    
    //TODO: ? Unit Test Poll Lights For State ? 
    
    private func makeSUT() -> LightsViewModel {
        let sut = LightsViewModel()
        return sut
    }

}
