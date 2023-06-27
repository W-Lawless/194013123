//
//  Data_Formatting_Tests.swift
//  Tests
//
//  Created by Lawless on 6/20/23.
//

import XCTest
@testable import MyCabin

final class Data_Formatting_Tests: XCTestCase {

    var mockData: ElementsRoot?
    
    override func setUp() async throws {
        let pathString = Bundle(for: type(of: self)).path(forResource: "Elements", ofType: "json")!
        let jsonString = try String(contentsOfFile: pathString, encoding: .utf8)
        let jsonData = jsonString.data(using: .utf8)!

        mockData = try! JSONDecoder().decode(ElementsRoot.self, from: jsonData)
    }
    
    func test_emptyDictionaryHasProperKeys() {
        let sut = getMockDataFormatter()
        let emptyDictionary = sut.buildEmptyDictionary()
        
        XCTAssertTrue(emptyDictionary["allAreas"] as? [AreaModel] != nil)
        XCTAssertTrue(emptyDictionary["allLights"] as? [LightModel] != nil)
        XCTAssertTrue(emptyDictionary["allSeats"] as? [SeatModel] != nil)
        XCTAssertTrue(emptyDictionary["allMonitors"] as? [MonitorModel] != nil)
        XCTAssertTrue(emptyDictionary["allSpeakers"] as? [SpeakerModel] != nil)
        XCTAssertTrue(emptyDictionary["allSources"] as? [SourceModel] != nil)
        XCTAssertTrue(emptyDictionary["allShades"] as? [ShadeModel] != nil)
        XCTAssertTrue(emptyDictionary["allTables"] as? [TableModel] != nil)
        XCTAssertTrue(emptyDictionary["allDivans"] as? [DivanModel] != nil)
        XCTAssertTrue(emptyDictionary["allTempCtrlrs"] as? [ClimateControllerModel] != nil)
       
    }
    
    func test_MapResultsToDictionary() {
        if let mockData {
            
            let sut = getMockDataFormatter()
            let dictionary = sut.mapResultsToDictionary(result: mockData)
            
            let allAreasResultCount = dictionary["allAreas"]?.count ?? 0
            let allLightsResultCount = dictionary["allLights"]?.count ?? 0
            let allSeatsResultCount = dictionary["allSeats"]?.count ?? 0
            let allMonitorsResultCount = dictionary["allMonitors"]?.count ?? 0
            let allSpeakersResultCount = dictionary["allSpeakers"]?.count ?? 0
            let allSourcesResultCount = dictionary["allSources"]?.count ?? 0
            let allShadesResultCount = dictionary["allShades"]?.count ?? 0
            let allTablesResultCount = dictionary["allTables"]?.count ?? 0
            let allDivansResultCount = dictionary["allDivans"]?.count ?? 0
            let allTempCtrlrsResultCount = dictionary["allTempCtrlrs"]?.count ?? 0
            
            XCTAssertTrue(allAreasResultCount > 0)
            XCTAssertTrue(allLightsResultCount > 0)
            XCTAssertTrue(allSeatsResultCount > 0)
            XCTAssertTrue(allMonitorsResultCount > 0)
            XCTAssertTrue(allSpeakersResultCount > 0)
            XCTAssertTrue(allSourcesResultCount > 0)
            XCTAssertTrue(allShadesResultCount > 0)
            XCTAssertTrue(allTablesResultCount > 0)
            XCTAssertTrue(allDivansResultCount > 0)
            XCTAssertTrue(allTempCtrlrsResultCount > 0)
            
        }
    }
    
    func test_MapLightsToSeat() {
        if let mockData {
            let sut = getMockDataFormatter()
            var dictionary = sut.mapResultsToDictionary(result: mockData)
            
            let seats = dictionary["allSeats"] as! [SeatModel]
            seats.forEach { seat in
                XCTAssertNil(seat.lights)
            }
            
            sut.mapLightsToSeat(elements: &dictionary)
            let mappedSeats = dictionary["allSeats"] as! [SeatModel]
            mappedSeats.forEach { seat in
                XCTAssertNotNil(seat.lights)
            }
        }
    }
    
    func test_FindUniqueSourceTypes() {
        if let mockData {
            let sut = getMockDataFormatter()
            var dictionary = sut.mapResultsToDictionary(result: mockData)
            let sourceTypes = sut.findUniqueSourceTypes(elements: &dictionary)
            XCTAssertTrue(sourceTypes.count == 10)
        }
    }
    
    func test_BuildPlaneMap() {
        if let mockData {
            let sut = getMockDataFormatter()
            var dictionary = sut.mapResultsToDictionary(result: mockData)
            let sourceTypes = sut.findUniqueSourceTypes(elements: &dictionary)
            
            let planeMap = sut.buildPlaneMap(dictionary: dictionary, sourceSet: sourceTypes)
            
            XCTAssertNotNil(planeMap.allLights)
            XCTAssertNotNil(planeMap.allSeats)
            XCTAssertNotNil(planeMap.allMonitors)
            XCTAssertNotNil(planeMap.allSpeakers)
            XCTAssertNotNil(planeMap.allSources)
            XCTAssertNotNil(planeMap.sourceTypes)
            XCTAssertNotNil(planeMap.allShades)
            XCTAssertNotNil(planeMap.allTables)
            XCTAssertNotNil(planeMap.allDivans)
            XCTAssertNotNil(planeMap.allTempCtrlrs)
        }
    }
    
    func test_MapElementsToPlaneAreas() {
        if let mockData {
            let sut = getMockDataFormatter()
            var dictionary = sut.mapResultsToDictionary(result: mockData)
            let sourceTypes = sut.findUniqueSourceTypes(elements: &dictionary)
            var planeMap = sut.buildPlaneMap(dictionary: dictionary, sourceSet: sourceTypes)
            
            let planeAreas = dictionary["allAreas"] as! [AreaModel]
            sut.mapElementsToPlaneAreas(allAreas: planeAreas, plane: &planeMap, elements: &dictionary)
            
            planeMap.mapAreas.forEach { area in
                XCTAssertNotNil(area.id)
                XCTAssertNotNil(area.rect)
            }
            XCTAssertNotNil(planeMap.parentArea)
            XCTAssertTrue(planeMap.mapAreas.count == 11)
        }
    }
    
    func test_FilterPlaneAreas() {
        if let mockData {
            let sut = getMockDataFormatter()
            var dictionary = sut.mapResultsToDictionary(result: mockData)
            let sourceTypes = sut.findUniqueSourceTypes(elements: &dictionary)
            var planeMap = sut.buildPlaneMap(dictionary: dictionary, sourceSet: sourceTypes)
            
            let planeAreas = dictionary["allAreas"] as! [AreaModel]
            sut.mapElementsToPlaneAreas(allAreas: planeAreas, plane: &planeMap, elements: &dictionary)
            sut.filterPlaneAreas(&planeMap)
            
            let containsJunkAreas = planeMap.mapAreas.contains { area in
                let eval = sut.regexFilter(area.id) && area.seats?.isEmpty != true
                return !eval //INVERSE OF FILTER PARAMETER
            }
            
            XCTAssertFalse(containsJunkAreas)
            XCTAssertTrue(planeMap.mapAreas.count == 3)
        }
    }
    
    func getMockDataFormatter() -> ElementDataFormatter {
        let mockState = StateFactory()
        let mockCacheUtil = FileCacheUtil(state: mockState)
        let sut = ElementDataFormatter(state: mockState, cacheUtil: mockCacheUtil)
        return sut
    }
    
}
