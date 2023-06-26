//
//  ViewTests.swift
//  Tests
//
//  Created by Lawless on 6/19/23.
//


import XCTest
import SwiftUI
import Combine
@testable import MyCabin
//TODO: - Refactor?
// remove >>> print statements

final class Navigation_Tests: XCTestCase {
    
    let mockPublisher = CurrentValueSubject<Bool, Never>(false)

    func test_ConnectionPublisher_InitsWithFalse() {
        XCTAssertFalse(PlaneFactory.cabinConnectionPublisher.value)
    }
    
    func test_AppCoordinator_LoadsRootNavigation() {
        let sut = makeSUT()
        sut.start { _ in } sinkValue: { _ in }
        let rootView = sut.rootNavView
        XCTAssertFalse(rootView.viewControllers.isEmpty)
    }
    
    func test_AppCoordinator_DisplaysLoadingViewOnInit() {
        let sut = makeSUT()
        
        let rootNavView = sut.rootNavView
        let loadingView = sut.loadingView
        
        sut.start(publisher: mockPublisher) { _ in } sinkValue: { _ in }
        XCTAssertEqual(rootNavView.visibleViewController,loadingView)
    }
    
    func test_AppCoordinator_DisplaysHomeMenuOnCabinConnection() {
        let exp = expectation(description: "Wait for publisher")
        
        let sut = makeSUT()
        
        let rootNavView = sut.rootNavView
        
        sut.start(publisher: mockPublisher) { _ in } sinkValue: { pulse in
            DispatchQueue.main.async {
                if(pulse) {
                    sut.goTo(.cabinFound)
                    exp.fulfill()
                }
            }
        }
        
        mockPublisher.send(true)
        
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertTrue(rootNavView.visibleViewController === sut.tabs.navigationController)
    }
    
    func test_AppCoordinator_DisplaysLoadingViewOnLostConnection() {
        let exp = expectation(description: "Wait for publisher")
        let mockedConnection = CurrentValueSubject<Bool, Never>(true)
        let sut = makeSUT()
        
        let rootNavView = sut.rootNavView
        let loadingView = sut.loadingView
        
        sut.start(publisher: mockedConnection) { _ in } sinkValue: { pulse in
            DispatchQueue.main.async {
                if(!pulse) {
                    sut.goTo(.loadCabin)
                    exp.fulfill()
                }
            }
        }
        
        mockedConnection.send(false)
        
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertTrue(rootNavView.visibleViewController === loadingView)
        
        
    }
    
    func test_HomeTabsView_SetsMonitorToProperInterval() {
        
        let sut = makeSUT()
        sut.goTo(.cabinFound)
        
        let interval = PlaneFactory.cabinAPI.monitor.currentInterval
        
        XCTAssertEqual(interval, 30.0)
        
        
    }
    
    func test_LoadingView_SetsMonitorToProperInterval() {
        let sut = makeSUT()
        
        sut.goTo(.loadCabin)
        
        let interval = PlaneFactory.cabinAPI.monitor.currentInterval
        
        XCTAssertEqual(interval, 3.0)
    }
    

    
    
    private func makeSUT() -> AppCoordinator {
        let sut = ViewFactory.AppCoordinator
        sut?.configureViews()
        return sut!
    }

}
