//
//  MediaTabUITests.swift
//  MyCabinUITests
//
//  Created by Lawless on 7/6/23.
//

import XCTest

final class SourceAssignmentUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
    }
    
    //MARK: - Open
    
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
    
    //MARK: - Display Options
    
    func test_SpeakerDisplayOptionShowsSpeakers() {
        app.launch()
        app.tabBars.buttons["MediaTab"].tap()
        app.buttons["speaker.wave.3"].tap()
        
        
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
    
    func test_MonitorDisplayOptionShowsMonitors() {
        app.launch()
        app.tabBars.buttons["MediaTab"].tap()
        app.buttons["speaker.wave.3"].tap()
        app.buttons["display"].tap()
        
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
    
    //MARK: - Monitors
    
    func test_MonitorButtonIconHighlightsOnTap() {
        app.launch()
        app.tabBars.buttons["MediaTab"].tap()
        app.images["AFT-BLKHD-4K-MON"].tap()
        let activeIcon = app.images["ic_sel_AFT-BLKHD-4K-MON"].exists
        let sourceSelectionPanel = app.scrollViews.otherElements/*@START_MENU_TOKEN@*/.images["CAMERA"]/*[[".images[\"ic_cameras\"]",".images[\"CAMERA\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists
        
        XCTAssertTrue(sourceSelectionPanel)
        XCTAssertTrue(activeIcon)
    }
    
    func test_MonitorButtonIconDeselectsOnSecondTap() {
        app.launch()
        app.tabBars.buttons["MediaTab"].tap()
        app.images["AFT-BLKHD-4K-MON"].tap()
        app.images["ic_sel_AFT-BLKHD-4K-MON"].tap()
        let activeIcon = app.images["ic_sel_AFT-BLKHD-4K-MON"].exists
        let sourceSelectionPanel = app.scrollViews.otherElements/*@START_MENU_TOKEN@*/.images["CAMERA"]/*[[".images[\"ic_cameras\"]",".images[\"CAMERA\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists

        XCTAssertFalse(activeIcon)
        XCTAssertFalse(sourceSelectionPanel)
    }
    
    func test_SelectMultipleMonitors() {
        app.launch()
        app.tabBars.buttons["MediaTab"].tap()
        app.images["AFT-BLKHD-4K-MON"].tap()
        app.images["FWD-RBLKHD-MON"].tap()
        
        let activeIcon = app.images["ic_sel_AFT-BLKHD-4K-MON"].exists
        let activeIcon2 = app.images["ic_sel_FWD-RBLKHD-MON"].exists
        
        XCTAssertTrue(activeIcon)
        XCTAssertTrue(activeIcon2)
        
        let sourceSelectionPanel = app.scrollViews.otherElements/*@START_MENU_TOKEN@*/.images["CAMERA"]/*[[".images[\"ic_cameras\"]",".images[\"CAMERA\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists
        XCTAssertTrue(sourceSelectionPanel)

    }
    
    func test_DeSelectMultipleMonitors() {
        app.launch()
        app.tabBars.buttons["MediaTab"].tap()
        app.images["AFT-BLKHD-4K-MON"].tap()
        app.images["FWD-RBLKHD-MON"].tap()
        app.images["ic_sel_AFT-BLKHD-4K-MON"].tap()
        app.images["ic_sel_FWD-RBLKHD-MON"].tap()
        
        let activeIcon = app.images["ic_sel_AFT-BLKHD-4K-MON"].exists
        let activeIcon2 = app.images["ic_sel_FWD-RBLKHD-MON"].exists
        let sourceSelectionPanel = app.scrollViews.otherElements/*@START_MENU_TOKEN@*/.images["CAMERA"]/*[[".images[\"ic_cameras\"]",".images[\"CAMERA\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists
        
        XCTAssertFalse(sourceSelectionPanel)
        XCTAssertFalse(activeIcon)
        XCTAssertFalse(activeIcon2)
    }
    
    //MARK: - Speakers
    
    func test_SpeakerIconHighlightsOnTap() {
        app.launch()
        app.tabBars.buttons["MediaTab"].tap()
        app.buttons["speaker.wave.3"].tap()
        app.images["L-SEAT-1-SPK-1"].tap()
        let activeIcon = app.images["ic_sel_L-SEAT-1-SPK-1"].exists
        let sourceSelectionPanel = app.scrollViews.otherElements/*@START_MENU_TOKEN@*/.images["CAMERA"]/*[[".images[\"ic_cameras\"]",".images[\"CAMERA\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists
        
        XCTAssertTrue(sourceSelectionPanel)
        XCTAssertTrue(activeIcon)
    }
    
    func test_SpeakerIconDeselectsOnSecondTap() {
        app.launch()
        app.tabBars.buttons["MediaTab"].tap()
        app.buttons["speaker.wave.3"].tap()
        app.images["L-SEAT-1-SPK-1"].tap()
        app.images["ic_sel_L-SEAT-1-SPK-1"].tap()
        let activeIcon = app.images["ic_sel_L-SEAT-1-SPK-1"].exists
        let sourceSelectionPanel = app.scrollViews.otherElements/*@START_MENU_TOKEN@*/.images["CAMERA"]/*[[".images[\"ic_cameras\"]",".images[\"CAMERA\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists
        
        XCTAssertFalse(sourceSelectionPanel)
        XCTAssertFalse(activeIcon)
    }
    
    func test_SelectMultipleSpeakers() {
        app.launch()
        app.tabBars.buttons["MediaTab"].tap()
        app.buttons["speaker.wave.3"].tap()
        app.images["L-SEAT-1-SPK-1"].tap()
        app.images["R-SEAT-1-SPK-1"].tap()
        let activeIcon = app.images["ic_sel_L-SEAT-1-SPK-1"].exists
        let activeIcon2 = app.images["ic_sel_R-SEAT-1-SPK-1"].exists
        let sourceSelectionPanel = app.scrollViews.otherElements/*@START_MENU_TOKEN@*/.images["CAMERA"]/*[[".images[\"ic_cameras\"]",".images[\"CAMERA\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists
        
        XCTAssertTrue(sourceSelectionPanel)
        XCTAssertTrue(activeIcon)
        XCTAssertTrue(activeIcon2)
    }
    
    func test_DeselectMultipleSpeakers() {
        app.launch()
        app.tabBars.buttons["MediaTab"].tap()
        app.buttons["speaker.wave.3"].tap()
        app.images["L-SEAT-1-SPK-1"].tap()
        app.images["R-SEAT-1-SPK-1"].tap()
        app.images["ic_sel_L-SEAT-1-SPK-1"].tap()
         app.images["ic_sel_R-SEAT-1-SPK-1"].tap()
        let activeIcon = app.images["ic_sel_L-SEAT-1-SPK-1"].exists
        let activeIcon2 = app.images["ic_sel_R-SEAT-1-SPK-1"].exists
        let sourceSelectionPanel = app.scrollViews.otherElements/*@START_MENU_TOKEN@*/.images["CAMERA"]/*[[".images[\"ic_cameras\"]",".images[\"CAMERA\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists
        
        XCTAssertFalse(sourceSelectionPanel)
        XCTAssertFalse(activeIcon)
        XCTAssertFalse(activeIcon2)
    }
    
    //MARK: - Panel
    
    func test_PanelButtonDisplaysListView() {
        app.launch()
        app.tabBars.buttons["MediaTab"].tap()
        app.images["AFT-BLKHD-4K-MON"].tap()
        app.scrollViews.otherElements/*@START_MENU_TOKEN@*/.images["CAMERA"]/*[[".images[\"ic_cameras\"]",".images[\"CAMERA\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let sourceListView = app.buttons["CAMERA_FWD"].exists
        
        XCTAssertTrue(sourceListView)
    }
    
    func test_SourceListButtonDisplaysSpeakerViewViaMonitor() {
        app.launch()
        app.tabBars.buttons["MediaTab"].tap()
        app.images["AFT-BLKHD-4K-MON"].tap()
        app.scrollViews.otherElements/*@START_MENU_TOKEN@*/.images["CAMERA"]/*[[".images[\"ic_cameras\"]",".images[\"CAMERA\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
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
    
    func test_SourceListButtonDisplaysMonitorViewViaSpeaker() {
        app.launch()
        app.tabBars.buttons["MediaTab"].tap()
        app.buttons["speaker.wave.3"].tap()
        app.images["L-SEAT-1-SPK-1"].tap()
        app.scrollViews.otherElements/*@START_MENU_TOKEN@*/.images["CAMERA"]/*[[".images[\"ic_cameras\"]",".images[\"CAMERA\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["CAMERA_FWD"].tap()
        
        let monitorIcon = app.images["AFT-BLKHD-4K-MON"].exists
        XCTAssertTrue(monitorIcon)
    }
    
    //MARK: - Confirmation
    
    func test_SpeakerIconForwardsToNowPlayingOnConfirm() {
        app.launch()
        app.tabBars.buttons["MediaTab"].tap()
        app.images["AFT-BLKHD-4K-MON"].tap()
        app.scrollViews.otherElements/*@START_MENU_TOKEN@*/.images["CAMERA"]/*[[".images[\"ic_cameras\"]",".images[\"CAMERA\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["CAMERA_FWD"].tap()
        app.images["L-SEAT-1-SPK-1"].tap()
        app.buttons["Confirm"].tap()
        
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
    
    func test_MonitorIconForwardsToNowPlayingOnConfirm() {
        app.launch()
        app.tabBars.buttons["MediaTab"].tap()
        app.buttons["speaker.wave.3"].tap()
        app.images["L-SEAT-1-SPK-1"].tap()
        app.scrollViews.otherElements/*@START_MENU_TOKEN@*/.images["CAMERA"]/*[[".images[\"ic_cameras\"]",".images[\"CAMERA\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["CAMERA_FWD"].tap()
        app.images["AFT-BLKHD-4K-MON"].tap()
        app.buttons["Confirm"].tap()
        
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
    
    //MARK: - Multiplicitous Assignments
    
    func test_MultipleMonitorsCorrectlyAssignWithOneSpeaker(){
        
        app.launch()
        app.tabBars.buttons["MediaTab"].tap()
        app.images["CREDENZA-MON"].tap()
        app.images["FWD-RBLKHD-MON"].tap()
        app.scrollViews.otherElements/*@START_MENU_TOKEN@*/.images["CABIN_VIEW"]/*[[".images[\"ic_cabinview\"]",".images[\"CABIN_VIEW\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.collectionViews/*@START_MENU_TOKEN@*/.buttons["CABIN_VIEW"]/*[[".cells",".buttons[\"CabinView\"]",".buttons[\"CABIN_VIEW\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.images["MID-SPK"].tap()
        app.buttons["Confirm"].tap()
        
        let activeMediaIcon1 = app.images["active_CREDENZA-MON"].exists
        let activeMediaIcon2 = app.images["active_FWD-RBLKHD-MON"].exists
        let activeMediaIcon3 = app.images["active_MID-SPK"].exists
        
        XCTAssertTrue(activeMediaIcon1)
        XCTAssertTrue(activeMediaIcon2)
        XCTAssertTrue(activeMediaIcon3)
                
    }
    
    func test_MultipleMonitorsCorrectlyAssignWithMultipleSpeakers(){
        
        app.launch()
        app.tabBars.buttons["MediaTab"].tap()
        app.images["CREDENZA-MON"].tap()
        app.images["FWD-RBLKHD-MON"].tap()
        app.scrollViews.otherElements/*@START_MENU_TOKEN@*/.images["CABIN_VIEW"]/*[[".images[\"ic_cabinview\"]",".images[\"CABIN_VIEW\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.collectionViews/*@START_MENU_TOKEN@*/.buttons["CABIN_VIEW"]/*[[".cells",".buttons[\"CabinView\"]",".buttons[\"CABIN_VIEW\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.images["MID-SPK"].tap()
        app.images["L-SEAT-2-SPK-1"].tap()
        app.buttons["Confirm"].tap()
        
        let activeMediaIcon1 = app.images["active_CREDENZA-MON"].exists
        let activeMediaIcon2 = app.images["active_FWD-RBLKHD-MON"].exists
        let activeMediaIcon3 = app.images["active_MID-SPK"].exists
        let activeMediaIcon4 = app.images["active_L-SEAT-2-SPK-1"].exists
        
        XCTAssertTrue(activeMediaIcon1)
        XCTAssertTrue(activeMediaIcon2)
        XCTAssertTrue(activeMediaIcon3)
        XCTAssertTrue(activeMediaIcon4)
                
    }
    
    func test_SingleMonitorCorrectlyAssignsWithMultipleSpeakers() {
        
        app.launch()
        app.tabBars.buttons["MediaTab"].tap()
        app.images["CREDENZA-MON"].tap()
        app.scrollViews.otherElements/*@START_MENU_TOKEN@*/.images["CABIN_VIEW"]/*[[".images[\"ic_cabinview\"]",".images[\"CABIN_VIEW\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.collectionViews/*@START_MENU_TOKEN@*/.buttons["CABIN_VIEW"]/*[[".cells",".buttons[\"CabinView\"]",".buttons[\"CABIN_VIEW\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.images["L-SEAT-1-SPK-1"].tap()
        app.images["MID-SPK"].tap()
        app.buttons["Confirm"].tap()
        
        let activeMediaIcon1 = app.images["active_CREDENZA-MON"].exists
        let activeMediaIcon2 = app.images["active_MID-SPK"].exists
        let activeMediaIcon3 = app.images["active_L-SEAT-1-SPK-1"].exists
        
        XCTAssertTrue(activeMediaIcon1)
        XCTAssertTrue(activeMediaIcon2)
        XCTAssertTrue(activeMediaIcon3)
                
    }
    
    func test_MultipleSpeakersCorrectlyAssignWithOneMonitor() {
        
        app.launch()
        app.tabBars.buttons["MediaTab"].tap()
        app/*@START_MENU_TOKEN@*/.buttons["speaker.wave.3"]/*[[".buttons[\"Volume Highest\"]",".buttons[\"speaker.wave.3\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.images["MID-SPK"].tap()
        app.images["L-SEAT-2-SPK-1"].tap()
        app.scrollViews.otherElements/*@START_MENU_TOKEN@*/.images["CABIN_VIEW"]/*[[".images[\"ic_cabinview\"]",".images[\"CABIN_VIEW\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.collectionViews/*@START_MENU_TOKEN@*/.buttons["CABIN_VIEW"]/*[[".cells",".buttons[\"CabinView\"]",".buttons[\"CABIN_VIEW\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.images["CREDENZA-MON"].tap()
        app.buttons["Confirm"].tap()
        
        let activeMediaIcon1 = app.images["active_MID-SPK"].exists
        let activeMediaIcon2 = app.images["active_L-SEAT-2-SPK-1"].exists
        let activeMediaIcon3 = app.images["active_CREDENZA-MON"].exists
        
        XCTAssertTrue(activeMediaIcon1)
        XCTAssertTrue(activeMediaIcon2)
        XCTAssertTrue(activeMediaIcon3)
                
    }
    
    func test_MultipleSpeakersCorrectlyAssignWithMultipleMonitors() {
        
        app.launch()
        app.tabBars.buttons["MediaTab"].tap()
        app/*@START_MENU_TOKEN@*/.buttons["speaker.wave.3"]/*[[".buttons[\"Volume Highest\"]",".buttons[\"speaker.wave.3\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.images["MID-SPK"].tap()
        app.images["L-SEAT-2-SPK-1"].tap()
        app.scrollViews.otherElements/*@START_MENU_TOKEN@*/.images["CABIN_VIEW"]/*[[".images[\"ic_cabinview\"]",".images[\"CABIN_VIEW\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.collectionViews/*@START_MENU_TOKEN@*/.buttons["CABIN_VIEW"]/*[[".cells",".buttons[\"CabinView\"]",".buttons[\"CABIN_VIEW\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.images["CREDENZA-MON"].tap()
        app.images["AFT-BLKHD-4K-MON"].tap()
        app.buttons["Confirm"].tap()
        
        let activeMediaIcon3 = app.images["active_MID-SPK"].exists
        let activeMediaIcon4 = app.images["active_L-SEAT-2-SPK-1"].exists
        let activeMediaIcon1 = app.images["active_CREDENZA-MON"].exists
        let activeMediaIcon2 = app.images["active_AFT-BLKHD-4K-MON"].exists
        
        XCTAssertTrue(activeMediaIcon1)
        XCTAssertTrue(activeMediaIcon2)
        XCTAssertTrue(activeMediaIcon3)
        XCTAssertTrue(activeMediaIcon4)
                
    }
    
    func test_SingleSpeakersCorrectlyAssignsWithMultipleMonitors() {
        
        app.launch()
        app.tabBars.buttons["MediaTab"].tap()
        app/*@START_MENU_TOKEN@*/.buttons["speaker.wave.3"]/*[[".buttons[\"Volume Highest\"]",".buttons[\"speaker.wave.3\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.images["MID-SPK"].tap()
        app.scrollViews.otherElements/*@START_MENU_TOKEN@*/.images["CABIN_VIEW"]/*[[".images[\"ic_cabinview\"]",".images[\"CABIN_VIEW\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.collectionViews/*@START_MENU_TOKEN@*/.buttons["CABIN_VIEW"]/*[[".cells",".buttons[\"CabinView\"]",".buttons[\"CABIN_VIEW\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.images["FWD-RBLKHD-MON"].tap()
        app.images["CREDENZA-MON"].tap()
        app.buttons["Confirm"].tap()
                
        let activeMediaIcon1 = app.images["active_MID-SPK"].exists
        let activeMediaIcon2 = app.images["active_FWD-RBLKHD-MON"].exists
        let activeMediaIcon3 = app.images["active_CREDENZA-MON"].exists
        
        XCTAssertTrue(activeMediaIcon1)
        XCTAssertTrue(activeMediaIcon2)
        XCTAssertTrue(activeMediaIcon3)
                
    }
    
    //MARK: - Persistence
    
    func test_Media_TabRetainsStateAcrossContexts() {
        
        app.launch()
        app.tabBars.buttons["MediaTab"].tap()
        app.images["AFT-BLKHD-4K-MON"].tap()
        app.scrollViews.otherElements/*@START_MENU_TOKEN@*/.images["CAMERA"]/*[[".images[\"ic_cameras\"]",".images[\"CAMERA\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["CAMERA_FWD"].tap()
        app.images["L-SEAT-1-SPK-1"].tap()
        app.buttons["Confirm"].tap()
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
   
}




