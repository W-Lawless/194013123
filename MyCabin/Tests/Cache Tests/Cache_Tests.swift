//
//  Cache_Tests.swift
//  Tests
//
//  Created by Lawless on 6/20/23.
//

import XCTest
@testable import MyCabin

final class Cache_Tests: XCTestCase {

    let mockData = MockData(name: "Test", id: .init())

    func test_CacheToFile() {
        let mockPath = makeTemporaryFilePathForTest()
        FileCacheUtil.cacheToFile(data: mockData, mockPath: mockPath)
        
        let data = FileManager.default.contents(atPath: "\(mockPath)/MockData.store")

        XCTAssertNotNil(data)
    }
    
    func test_RetrieveFromCache() {
        let mockPath = makeTemporaryFilePathForTest()
        FileCacheUtil.cacheToFile(data: mockData, mockPath: mockPath)
        let data = try? FileCacheUtil.retrieveCachedFile(dataModel: MockData.self, mockPath: mockPath)
        XCTAssertNotNil(data)
    }
    
    struct MockData: Codable {
        var name: String
        var id: UUID
    }
    
    func makeTemporaryFilePathForTest() -> String {
        let path = NSTemporaryDirectory() + "cache_tests"
        try? FileManager.default.removeItem(atPath: path)
        return path
    }
    
    override func tearDown() {
        let mockDirectory = makeTemporaryFilePathForTest()
        do {
            try FileManager.default.removeItem(atPath: mockDirectory)
        } catch {
            print(error)
        }
    }

}
