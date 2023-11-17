//
//  MediaTabView_Tests.swift
//  Tests
//
//  Created by Lawless on 6/20/23.
//

import XCTest
@testable import MyCabin

final class MediaTests: XCTestCase {

    func test_SelectMonitor() {
        let sut = makeSUT()
        let mockData = MonitorModel(id: "monitor1")
        sut.selectMonitor(monitor: mockData)
        
        XCTAssertEqual(sut.selectedMonitors.first, mockData)
    }
    
    func test_SelectMultipleMonitors() {
        let sut = makeSUT()
        let mockData = [MonitorModel(id: "monitor1"), MonitorModel(id: "monitor2")]
        sut.selectMonitor(monitor: mockData[0])
        sut.selectMonitor(monitor: mockData[1])
        
        XCTAssertEqual(sut.selectedMonitors, mockData)
    }
    
    func test_SelectSpeaker() {
        let sut = makeSUT()
        let mockData = SpeakerModel(id: "speaker1")
        sut.selectSpeaker(speaker: mockData)
        
        XCTAssertEqual(sut.selectedSpeakers.first, mockData)
    }
    
    func test_SelectMultipleSpeakers() {}
    
    func test_SelectActiveSource() {
        let (sut, sSUT) = make_sSUT()
        let mockData = SourceModel(id: "source1")
        sSUT.selectActiveSource(mockData)
        
        XCTAssertEqual(sSUT.selectedSource, mockData)
    }
    
    func test_AssignSourceToOutput_case_ExistingActiveMediaObject() {
        let (sut, sSUT) = make_sSUT()
        let mockSource = SourceModel(id: "source1")
        let mockActiveMedia = ActiveMedia(id: .init(), source: mockSource)
        let mockMonitors = [MonitorModel(id: "monitor1"), MonitorModel(id: "monitor2")]
        let mockSpeakers = [SpeakerModel(id: "speaker1"), SpeakerModel(id: "speaker2")]
        
        sut.selectMonitor(monitor: mockMonitors[0])
        sut.selectMonitor(monitor: mockMonitors[1])
        sut.selectSpeaker(speaker: mockSpeakers[0])
        sut.selectSpeaker(speaker: mockSpeakers[1])
        sSUT.selectActiveSource(mockSource)

        sSUT.activeMedia[mockActiveMedia.id] = mockActiveMedia
        sSUT.assignSourceToOutput()
        
        XCTAssertEqual(sSUT.activeMedia[mockActiveMedia.id]?.monitors, mockMonitors)
        XCTAssertEqual(sSUT.activeMedia[mockActiveMedia.id]?.speakers, mockSpeakers)
    }
    
    func test_AssignSourceToMonitorGroup_case_NoExistingActiveMediaObject() {
        let (sut, sSUT) = make_sSUT()
        let mockSource = SourceModel(id: "source1")
        let mockMonitors = [MonitorModel(id: "monitor1"), MonitorModel(id: "monitor2")]
        let mockSpeakers = [SpeakerModel(id: "speaker1"), SpeakerModel(id: "speaker2")]

        
        sut.selectMonitor(monitor: mockMonitors[0])
        sut.selectMonitor(monitor: mockMonitors[1])
        sut.selectSpeaker(speaker: mockSpeakers[0])
        sut.selectSpeaker(speaker: mockSpeakers[1])
        sSUT.selectActiveSource(mockSource)
        
        sSUT.assignSourceToOutput()
        
        XCTAssertEqual(sSUT.activeMedia.first?.value.monitors, mockMonitors)
        XCTAssertEqual(sSUT.activeMedia.first?.value.speakers, mockSpeakers)
    }
    
    private func makeSUT() -> MediaViewModel {
        let sut = MediaViewModel()
        return sut
    }
    
    private func make_sSUT() -> (MediaViewModel, ActiveMediaViewModel) {
        let sut = makeSUT()
        let secondarySUT = ActiveMediaViewModel(mediaViewModel: sut)
        return (sut, secondarySUT)
    }

}
