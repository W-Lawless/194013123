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

    func test_OpenSeatsMenu() {
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
    
    func test_OpenShadesMenu() {
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
    
    func test_OpenLightsMenu() {
        app.launch()
        app.images["LightsMenu"].tap()
        
        let lightOptionBtn1 = app.buttons["lightZones"].exists
        let lightOptionBtn2 = app.buttons["showLights"].exists
        
        XCTAssertTrue(lightOptionBtn1)
        XCTAssertTrue(lightOptionBtn2)
    }
    
    func test_OpenLightZonesMenu() {
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
    
    func test_LightsMenuOpensBottomPanel() {
        app.launch()
        app.images["LightsMenu"].tap()
        app.images["L-SEAT-1-1"].tap()
        
        let lightCtrlPanel = app.scrollViews["lightControlPanel"].exists
        
        XCTAssertTrue(lightCtrlPanel)
    }
    
    func test_OpenMediaTab()  {
        app.launch()
        app.tabBars.buttons["MediaTab"].tap()
        
        let monitorBtn1 = app.images["AFT-BLKHD-4K-MON"].exists
        let monitorBtn2 = app.images["R-SEAT-2-MON-1"].exists
        let monitorBtn3 = app.images["FWD-RBLKHD-MON"].exists
        let monitorBtn4 = app.images["R-SEAT-2-MON-3"].exists
        let monitorBtn5 = app.images["AFT-BLKHD-MON"].exists
        let monitorBtn6 = app.images["CREDENZA-MON"].exists
        
        XCTAssertTrue(monitorBtn1)
        XCTAssertTrue(monitorBtn2)
        XCTAssertTrue(monitorBtn3)
        XCTAssertTrue(monitorBtn4)
        XCTAssertTrue(monitorBtn5)
        XCTAssertTrue(monitorBtn6)
    }
    
    func test_MediaTabMonitorButtonOpensSourcePanel() {
        app.launch()
        app.tabBars.buttons["MediaTab"].tap()
        app.images["AFT-BLKHD-4K-MON"].tap()
        let sourceSelectionPanel = app.buttons["CAMERA"].exists
        XCTAssertTrue(sourceSelectionPanel)
    }
    
    func test_MediaSourceButtonPresentsSourceListView() {
        app.launch()
        app.tabBars.buttons["MediaTab"].tap()
        app.images["AFT-BLKHD-4K-MON"].tap()
        app.buttons["CAMERA"].tap()
        let sourceListView = app.buttons["CAMERA_FWD"].exists
        
        XCTAssertTrue(sourceListView)
    }
    
    func test_SourceListButtonPushesSpeakerView() {
        app.launch()
        app.tabBars.buttons["MediaTab"].tap()
        app.images["AFT-BLKHD-4K-MON"].tap()
        app.buttons["CAMERA"].tap()
        let sourceListView = app.buttons["CAMERA_FWD"].exists
        
        XCTAssertTrue(sourceListView)
    }
    
}
