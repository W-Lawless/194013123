//
//  ActiveMediaUITests.swift
//  MyCabinUITests
//
//  Created by Lawless on 7/6/23.
//

import XCTest

final class ActiveMediaUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
    }
    
    func test_ActiveMedia_MonitorIconDisplaysMonitorControlPanel() {
        app.launch()
        app.tabBars.buttons["MediaTab"].tap()
        app.images["AFT-BLKHD-4K-MON"].tap()
        app.scrollViews.otherElements/*@START_MENU_TOKEN@*/.images["CAMERA"]/*[[".images[\"ic_cameras\"]",".images[\"CAMERA\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["CAMERA_FWD"].tap()
        app.images["L-SEAT-1-SPK-1"].tap()
        app.buttons["Confirm"].tap()
        app.images["active_AFT-BLKHD-4K-MON"].tap()
        
        let activeMediaDeviceIcon = app.images["active_device_monitor"].exists
        let activeMediaSourceIcon = app.images["source_icon_CAMERA_FWD"].exists
        
        XCTAssertTrue(activeMediaDeviceIcon)
        XCTAssertTrue(activeMediaSourceIcon)
    }
    
    func test_ActiveMedia_SpeakerIconDisplaysSpeakerControlPanel() {
        app.launch()
        app.tabBars.buttons["MediaTab"].tap()
        app.images["AFT-BLKHD-4K-MON"].tap()
        app.scrollViews.otherElements/*@START_MENU_TOKEN@*/.images["CAMERA"]/*[[".images[\"ic_cameras\"]",".images[\"CAMERA\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["CAMERA_FWD"].tap()
        app.images["L-SEAT-1-SPK-1"].tap()
        app.buttons["Confirm"].tap()
        app.images["active_L-SEAT-1-SPK-1"].tap()
        
        let activeMediaDeviceIcon = app.images["active_device_speaker"].exists
        let activeMediaSourceIcon = app.images["source_icon_CAMERA_FWD"].exists
        
        XCTAssertTrue(activeMediaDeviceIcon)
        XCTAssertTrue(activeMediaSourceIcon)
    }
    
    func test_ActiveMedia_ShowMonitorsOptionDisplaysMonitors() {
        app.launch()
        app.tabBars.buttons["MediaTab"].tap()
        app.images["AFT-BLKHD-4K-MON"].tap()
        app.scrollViews.otherElements/*@START_MENU_TOKEN@*/.images["CAMERA"]/*[[".images[\"ic_cameras\"]",".images[\"CAMERA\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["CAMERA_FWD"].tap()
        app.images["L-SEAT-1-SPK-1"].tap()
        app.buttons["Confirm"].tap()
        app.buttons["display"].tap()
        
        XCTAssertTrue(app.images["AFT-BLKHD-4K-MON"].exists)
    }
    
    func test_ActiveMedia_ShowNowPlayingOptionDisplaysNowPlaying() {
        app.launch()
        app.tabBars.buttons["MediaTab"].tap()
        app.images["AFT-BLKHD-4K-MON"].tap()
        app.scrollViews.otherElements/*@START_MENU_TOKEN@*/.images["CAMERA"]/*[[".images[\"ic_cameras\"]",".images[\"CAMERA\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["CAMERA_FWD"].tap()
        app.images["L-SEAT-1-SPK-1"].tap()
        app.buttons["Confirm"].tap()
        app.buttons["display"].tap()
        app.buttons["play.display"].tap()
        
        XCTAssertTrue(app.images["active_AFT-BLKHD-4K-MON"].exists)
    }
}
