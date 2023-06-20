//
//  Data_Formatting_Tests.swift
//  Tests
//
//  Created by Lawless on 6/20/23.
//

import XCTest
@testable import MyCabin

final class Data_Formatting_Tests: XCTestCase {

    func testExample() async {
        let viewModel = PlaneViewModel()
        var sut = ElementsAPI(viewModel: viewModel)
        await sut.fetch()
        
        XCTAssertNotNil(viewModel.$plane)
    }

    
}
