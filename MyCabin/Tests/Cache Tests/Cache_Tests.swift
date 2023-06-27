//
//  Cache_Tests.swift
//  Tests
//
//  Created by Lawless on 6/20/23.
//

import XCTest
@testable import MyCabin

final class Cache_Tests: XCTestCase {

    private let mockData = MockData(name: "Test", id: .init())
    
    func test_CacheToFile() {
        let mockPath = makeTemporaryFilePathForTest()
        let mockCacheUtil = getMockCacheUtil()
        mockCacheUtil.cacheToFile(data: mockData, mockPath: mockPath)
        
        let data = FileManager.default.contents(atPath: "\(mockPath)/MockData.store")

        XCTAssertNotNil(data)
    }
    
    func test_RetrieveFromCache() {
        let mockPath = makeTemporaryFilePathForTest()
        let mockCacheUtil = getMockCacheUtil()
        mockCacheUtil.cacheToFile(data: mockData, mockPath: mockPath)
        let data = try? mockCacheUtil.retrieveCachedFile(dataModel: MockData.self, mockPath: mockPath)
        XCTAssertNotNil(data)
    }
    
    private struct MockData: Codable {
        var name: String
        var id: UUID
    }
    
    private func getMockCacheUtil() -> FileCacheUtil {
        let mockStateObjects = StateFactory()
        let mockCacheUtil = FileCacheUtil(state: mockStateObjects)
        return mockCacheUtil
    }
    
    private func makeTemporaryFilePathForTest() -> String {
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
