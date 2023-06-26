//
//  MyCabinUITests.swift
//  MyCabinUITests
//
//  Created by Lawless on 6/21/23.
//

import XCTest

final class MyCabinUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
    }

    func test_SeatsMenu_Opens() {
        app.launch()
        app.images["LightsMenu"].tap()
        
        let seatIcon1 = app.images["L-SEAT-1-1"].exists
        let seatIcon2 = app.images["R-SEAT-1-1"].exists
        let seatIcon3 = app.images["L-SEAT-2-1"].exists
        let seatIcon4 = app.images["R-SEAT-2-1"].exists
        let seatIcon5 = app.images["CONF-FWD-OB-2"].exists
        let seatIcon6 = app.images["CONF-FWD-IB-2"].exists
        let seatIcon7 = app.images["CONF-AFT-OB-2"].exists
        let seatIcon8 = app.images["CONF-AFT-IB-2"].exists
        let seatIcon9 = app.images["R-SEAT-1-3"].exists
        let seatIcon10 = app.images["R-SEAT-2-3"].exists
        
        let tableIcon1 = app.images["L-TBL-1"].exists
        let tableIcon2 = app.images["R-TBL-1"].exists
        let tableIcon3 = app.images["CONF-SEAT-TBL-2"].exists
        let tableIcon4 = app.images["CREDENZA-2"].exists
        let tableIcon5 = app.images["DIVAN-GRP-R-TBL-3"].exists
        
        let divanIcon = app.images["DIVAN-3"].exists
        
        XCTAssertTrue(seatIcon1)
        XCTAssertTrue(seatIcon2)
        XCTAssertTrue(seatIcon3)
        XCTAssertTrue(seatIcon4)
        XCTAssertTrue(seatIcon5)
        XCTAssertTrue(seatIcon6)
        XCTAssertTrue(seatIcon7)
        XCTAssertTrue(seatIcon8)
        XCTAssertTrue(seatIcon9)
        XCTAssertTrue(seatIcon10)
        
        XCTAssertTrue(tableIcon1)
        XCTAssertTrue(tableIcon2)
        XCTAssertTrue(tableIcon3)
        XCTAssertTrue(tableIcon4)
        XCTAssertTrue(tableIcon5)
        
        XCTAssertTrue(divanIcon)
    }
    
    func test_ShadesMenu_Opens() {
        app.launch()
        app.images["ShadesMenu"].tap()
        
        let shadeOptionBtn1 = app.buttons["All"].exists
        let shadeOptionBtn2 = app.buttons["Left"].exists
        let shadeOptionBtn3 = app.buttons["Right"].exists
        
        let shadeIcon1 = app.images["L-SEAT-1-WDO-1"].exists
        let shadeIcon2 = app.images["R-SEAT-1-WDO-1"].exists
        let shadeIcon3 = app.images["L-SEAT-2-WDO-1"].exists
        let shadeIcon4 = app.images["R-SEAT-2-WDO-1"].exists
        let shadeIcon5 = app.images["L-CONF-GRP-WDO-1-2"].exists
        let shadeIcon6 = app.images["R-CONF-GRP-WDO-1-2"].exists
        let shadeIcon7 = app.images["L-CONF-GRP-WDO-2-2"].exists
        let shadeIcon8 = app.images["R-CONF-GRP-WDO-2-2"].exists
        let shadeIcon9 = app.images["L-DIVAN-GRP-WDO-1-3"].exists
        let shadeIcon10 = app.images["WDO-1-3"].exists
        let shadeIcon11 = app.images["L-DIVAN-GRP-WDO-2-3"].exists
        let shadeIcon12 = app.images["WDO-2-3"].exists
        
        XCTAssertTrue(shadeOptionBtn1)
        XCTAssertTrue(shadeOptionBtn2)
        XCTAssertTrue(shadeOptionBtn3)
        
        XCTAssertTrue(shadeIcon1)
        XCTAssertTrue(shadeIcon2)
        XCTAssertTrue(shadeIcon3)
        XCTAssertTrue(shadeIcon4)
        XCTAssertTrue(shadeIcon5)
        XCTAssertTrue(shadeIcon6)
        XCTAssertTrue(shadeIcon7)
        XCTAssertTrue(shadeIcon8)
        XCTAssertTrue(shadeIcon9)
        XCTAssertTrue(shadeIcon10)
        XCTAssertTrue(shadeIcon11)
        XCTAssertTrue(shadeIcon12)
    }
    
    func test_LightsMenu_Opens() {
        app.launch()
        app.images["LightsMenu"].tap()
        
        let lightOptionBtn1 = app.buttons["lightZones"].exists
        let lightOptionBtn2 = app.buttons["showLights"].exists
        
        XCTAssertTrue(lightOptionBtn1)
        XCTAssertTrue(lightOptionBtn2)
    }
    
    func test_LightsMenu_ShowsZones() {
        app.launch()
        app.images["LightsMenu"].tap()
        
        app.buttons["lightZones"].tap()
        
        let zone1 = app.otherElements["tappable_FWD-GRP"].exists
        let zone2 = app.otherElements["tappable_MID-GRP"].exists
        let zone3 = app.otherElements["tappable_AFT-GRP"].exists
        
        XCTAssertTrue(zone1)
        XCTAssertTrue(zone2)
        XCTAssertTrue(zone3)
    }
    
    func test_LightsMenu_ZoneTappableArea() {
//        app.launch()
//        app.images["LightsMenu"].tap()
//        app.buttons["lightZones"].tap()
//        let zone1 = app.otherElements["tappable_FWD-GRP"]
//        zone1.tap()
//        let active_zone1 = app.otherElements["tapped_FWD-GRP"]
        
        //TODO: - Placeholder 
        //XCTAssertTrue(active_zone1.exists)
        
    }
    
    func test_LightsMenu_OpensBottomPanel() {
        app.launch()
        app.images["LightsMenu"].tap()
        app.images["L-SEAT-1-1"].tap()
        
        let lightCtrlPanel = app.scrollViews["lightControlPanel"].exists
        
        XCTAssertTrue(lightCtrlPanel)
    }
    
    func test_Media_OpenTab()  {
        app.launch()
        app.tabBars.buttons["MediaTab"].tap()
        
        let monitorBtn1 = app.images["AFT-BLKHD-4K-MON"].exists
        let monitorBtn2 = app.images["R-SEAT-2-MON-1"].exists
        let monitorBtn3 = app.images["FWD-RBLKHD-MON"].exists
        let monitorBtn4 = app.images["R-SEAT-2-MON-3"].exists
        let monitorBtn5 = app.images["AFT-BLKHD-MON"].exists
        let monitorBtn6 = app.images["CREDENZA-MON"].exists
        
        XCTAssertTrue(app.buttons["display"].exists)
        XCTAssertTrue(app.buttons["speaker.wave.3"].exists)
        XCTAssertTrue(app.buttons["headphones"].exists)
        
        XCTAssertTrue(monitorBtn1)
        XCTAssertTrue(monitorBtn2)
        XCTAssertTrue(monitorBtn3)
        XCTAssertTrue(monitorBtn4)
        XCTAssertTrue(monitorBtn5)
        XCTAssertTrue(monitorBtn6)
    }
    
    func test_Media_AssignSource_MonitorButtonDisplaysSourcePanel() {
        app.launch()
        app.tabBars.buttons["MediaTab"].tap()
        app.images["AFT-BLKHD-4K-MON"].tap()
        let sourceSelectionPanel = app.buttons["CAMERA"].exists
        XCTAssertTrue(sourceSelectionPanel)
    }
    
    func test_Media_AssignSource_MonitorButtonHidesSourcePanel() {
        app.launch()
        app.tabBars.buttons["MediaTab"].tap()
        app.images["AFT-BLKHD-4K-MON"].tap()
        app.images["AFT-BLKHD-4K-MON"].tap()
        let sourceSelectionPanel = app.buttons["CAMERA"].exists
        XCTAssertFalse(sourceSelectionPanel)
    }
    
    func test_Media_AssignSource_MonitorButtonSwapsPanelContext() {
        app.launch()
        app.tabBars.buttons["MediaTab"].tap()
        let mon1 = app.images["AFT-BLKHD-4K-MON"]
        mon1.tap()
        
        app.images["R-SEAT-2-MON-1"].tap()
        let sourceSelectionPanel = app.buttons["CAMERA"].exists
        XCTAssertTrue(sourceSelectionPanel)
    }
    
    func test_Media_AssignSource_PanelButtonDisplaysListView() {
        app.launch()
        app.tabBars.buttons["MediaTab"].tap()
        app.images["AFT-BLKHD-4K-MON"].tap()
        app.buttons["CAMERA"].tap()
        let sourceListView = app.buttons["CAMERA_FWD"].exists
        
        XCTAssertTrue(sourceListView)
    }
    
    func test_Media_AssignSource_ListButtonDisplaysSpeakerView() {
        app.launch()
        app.tabBars.buttons["MediaTab"].tap()
        app.images["AFT-BLKHD-4K-MON"].tap()
        app.buttons["CAMERA"].tap()
        app.buttons["CAMERA_FWD"].tap()
        
        let speakerIcon1 = app.images["L-SEAT-1-SPK-1"].exists
        let speakerIcon2 = app.images["R-SEAT-1-SPK-1"].exists
        let speakerIcon3 = app.images["R-SEAT-2-SPK-1"].exists
        let speakerIcon4 = app.images["R-SEAT-2-SPK-1"].exists
        let speakerIcon5 = app.images["L-SEAT-2-SPK-1"].exists
        let speakerIcon6 = app.images["MID-SPK"].exists
        let speakerIcon7 = app.images["SEAT-1-SPK-3"].exists
        let speakerIcon8 = app.images["DIVAN-FWD-SPK-3"].exists
        let speakerIcon9 = app.images["DIVAN-AFT-SPK-3"].exists
        let speakerIcon10 = app.images["AFT-SPK"].exists
        let speakerIcon11 = app.images["SEAT-2-SPK-3"].exists
        
        XCTAssertTrue(speakerIcon1)
        XCTAssertTrue(speakerIcon2)
        XCTAssertTrue(speakerIcon3)
        XCTAssertTrue(speakerIcon4)
        XCTAssertTrue(speakerIcon5)
        XCTAssertTrue(speakerIcon6)
        XCTAssertTrue(speakerIcon7)
        XCTAssertTrue(speakerIcon8)
        XCTAssertTrue(speakerIcon9)
        XCTAssertTrue(speakerIcon10)
        XCTAssertTrue(speakerIcon11)
    }
    
    func test_Media_AssignSource_SpeakerIconForwardsToNowPlaying() {
        app.launch()
        app.tabBars.buttons["MediaTab"].tap()
        app.images["AFT-BLKHD-4K-MON"].tap()
        app.buttons["CAMERA"].tap()
        app.buttons["CAMERA_FWD"].tap()
        app.images["L-SEAT-1-SPK-1"].tap()
        
        let activeMediaIcon1 = app.images["active_AFT-BLKHD-4K-MON"].exists
        let activeMediaIcon2 = app.images["active_L-SEAT-1-SPK-1"].exists
        
        XCTAssertTrue(activeMediaIcon1)
        XCTAssertTrue(activeMediaIcon2)
        
        XCTAssertTrue(app.buttons["display"].exists)
        XCTAssertTrue(app.buttons["play.display"].exists)
        XCTAssertTrue(app.buttons["speaker.wave.3"].exists)
        XCTAssertTrue(app.buttons["headphones"].exists)
        XCTAssertTrue(app.buttons["appletvremote.gen2"].exists)
    }
    
    func test_Media_TabRetainsStateAcrossContexts() {
        
        app.launch()
        app.tabBars.buttons["MediaTab"].tap()
        app.images["AFT-BLKHD-4K-MON"].tap()
        app.buttons["CAMERA"].tap()
        app.buttons["CAMERA_FWD"].tap()
        app.images["L-SEAT-1-SPK-1"].tap()
        app.tabBars.buttons["HomeTab"].tap()
        app.tabBars.buttons["MediaTab"].tap()
        
        let activeMediaIcon1 = app.images["active_AFT-BLKHD-4K-MON"].exists
        let activeMediaIcon2 = app.images["active_L-SEAT-1-SPK-1"].exists
        
        XCTAssertTrue(activeMediaIcon1)
        XCTAssertTrue(activeMediaIcon2)
        
        XCTAssertTrue(app.buttons["display"].exists)
        XCTAssertTrue(app.buttons["play.display"].exists)
        XCTAssertTrue(app.buttons["speaker.wave.3"].exists)
        XCTAssertTrue(app.buttons["headphones"].exists)
        XCTAssertTrue(app.buttons["appletvremote.gen2"].exists)
    }
    
    func test_ActiveMedia_MonitorIconDisplaysMonitorControlPanel() {
        app.launch()
        app.tabBars.buttons["MediaTab"].tap()
        app.images["AFT-BLKHD-4K-MON"].tap()
        app.buttons["CAMERA"].tap()
        app.buttons["CAMERA_FWD"].tap()
        app.images["L-SEAT-1-SPK-1"].tap()
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
        app.buttons["CAMERA"].tap()
        app.buttons["CAMERA_FWD"].tap()
        app.images["L-SEAT-1-SPK-1"].tap()
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
        app.buttons["CAMERA"].tap()
        app.buttons["CAMERA_FWD"].tap()
        app.images["L-SEAT-1-SPK-1"].tap()
        app.buttons["display"].tap()
        
        XCTAssertTrue(app.images["AFT-BLKHD-4K-MON"].exists)
    }
    
    func test_ActiveMedia_ShowNowPlayingOptionDisplaysNowPlaying() {
        app.launch()
        app.tabBars.buttons["MediaTab"].tap()
        app.images["AFT-BLKHD-4K-MON"].tap()
        app.buttons["CAMERA"].tap()
        app.buttons["CAMERA_FWD"].tap()
        app.images["L-SEAT-1-SPK-1"].tap()
        app.buttons["display"].tap()
        app.buttons["play.display"].tap()
        
        XCTAssertTrue(app.images["active_AFT-BLKHD-4K-MON"].exists)
    }
    
    
}
