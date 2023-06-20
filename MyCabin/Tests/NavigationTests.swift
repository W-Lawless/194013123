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

final class Navigation_Tests: XCTestCase {
    
    let mockPublisher = CurrentValueSubject<Bool, Never>(false)

    func test_ConnectionPublisher_InitsWithFalse() {
        XCTAssertFalse(PlaneFactory.cabinConnectionPublisher.value)
    }

    func test_AppCoordinator_LoadsRootNavigation() {
        let sut = ViewFactory.AppCoordinator
        if let sut {
            sut.start { _ in } sinkValue: { _ in }
            let rootView = sut.rootNavView
            XCTAssertFalse(rootView.viewControllers.isEmpty)
        }
    }

    func test_AppCoordinator_DisplaysLoadingViewOnInit() {

        let exp = expectation(description: "Wait for publisher")

        let sut = ViewFactory.AppCoordinator

        if let sut {

            let rootNavView = sut.rootNavView
            let loadingView = sut.loadingView

            sut.start(publisher: mockPublisher) { completion in
                return
            } sinkValue: { pulse in
                DispatchQueue.main.async {
                    pulse
                    ? sut.goTo(.cabinFound)
                    : sut.goTo(.loadCabin)
                    exp.fulfill()
                }
            }

            wait(for: [exp], timeout: 1.0)

            XCTAssertTrue(rootNavView.visibleViewController === loadingView)

        }
    }
    
    func test_AppCoordinator_DisplaysHomeMenuOnCabinConnection() {
        let exp = expectation(description: "Wait for publisher")
        
        let sut = ViewFactory.AppCoordinator
        
        if let sut {
        
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
    }
    
    func test_AppCoordinator_DisplaysLoadingViewOnLostConnection() {
        let exp = expectation(description: "Wait for publisher")
        let mockedConnection = CurrentValueSubject<Bool, Never>(true)
        let sut = ViewFactory.AppCoordinator
        
        if let sut {
        
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
    }
    
    func test_HomeTabsView_SetsMonitorToProperInterval() {

        let sut = ViewFactory.AppCoordinator
        
        if let sut {
            sut.goTo(.cabinFound)

            let interval = PlaneFactory.cabinAPI.monitor.currentInterval
            
            XCTAssertEqual(interval, 30.0)

        }
    }
    
    func test_LoadingView_SetsMonitorToProperInterval() {
        let sut = ViewFactory.AppCoordinator
        
        if let sut {
            
            sut.goTo(.loadCabin)
                    
            let interval = PlaneFactory.cabinAPI.monitor.currentInterval

            XCTAssertEqual(interval, 3.0)

        }
    }
    

    
    //TODO: - Test Router / Error Cases
    
    
//    func testMenuRouter() throws {
//        let coordinator = NavigationFactory.buildHomeMenu()
//        let targetView = MenuRouter.lights.view()
//
//        coordinator.navigationController.pushViewController(targetView, animated: false)
//
//        let visible = coordinator.navigationController.visibleViewController
//
//        XCTAssertTrue(visible === targetView)
//    }


}

