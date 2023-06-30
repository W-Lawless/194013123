//
//  ActiveMediaControlPanel.swift
//  MyCabin
//
//  Created by Lawless on 5/9/23.
//

import SwiftUI

struct ActiveMediaControlPanel: View {
    
    @EnvironmentObject var mediaViewModel: MediaViewModel
    @State var mute: Bool = false
    @State var volume: Int = 25
    @State var monitorPower: Bool = true
    @State var dummyBinding: Bool = false
    
    @ObservedObject var activeMediaViewModel: ActiveMediaViewModel
    let activeMedia: ActiveMedia
    let device: MediaDevice
    let navHandler: () -> ()
    
    
    var body: some View {
        
        //TODO: -- Componentize
        GeometryReader { geo in
            
            ScrollView(.horizontal) {
                
                HStack(spacing: 24) {
                    
                    Image(getDeviceIcon())
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .accessibilityIdentifier("active_device_\(device.rawValue)")
                    
                    SourceSelectionButton(image: "stop.circle", label: "Stop", uilabel: "source_icon_\(activeMedia.source.id)", sysimg: true)
                    .hapticFeedback(feedbackStyle: .medium) { _ in
                        //TODO: - Refactor subview generation
                        activeMediaViewModel.removeActiveMedia(mediaToMakeInactive: activeMedia)
                    }
                    
                    //TODO: - Generic 'Button' Builder
                    SourceSelectionButton(image: getSourceIcon(), label: activeMedia.source.name, uilabel: activeMedia.source.id)
                    .hapticFeedback(feedbackStyle: .medium) { _ in
                        navHandler()
                    }
                        
                    loadProperControlButtons()
                    
                } //:HSTQ
                .padding(.horizontal, (geo.size.width * 0.08))
                
                
            } //: SCRLL
            
        } //: GEO
        .frame(height: 108)
        
    }
    
    //TODO: - Investigate view builder ?
    //TODO: - ActiveMediaControl Button Wrap into Button Builder
    @ViewBuilder
    func loadProperControlButtons() -> some View {
        switch(device) {
        case .speaker:
            
            ActiveMediaControlButton(image: "speaker.plus", imageSelected:  "speaker.plus", label: "volume+", selectionBinding: $dummyBinding) {
                if (volume < 100) {
                    volume = volume + 5
                    print(volume)
                    //apiClient.setVolume(activeMedia.speaker!, volume: volume)
                }
            }
            
            ActiveMediaControlButton(image: "speaker.minus", imageSelected: "speaker.minus", label: "volume-", selectionBinding: $dummyBinding) {
                if(volume > 0) {
                    volume = volume - 5
                    print(volume)
                    //apiClient.setVolume(activeMedia.speaker!, volume: volume)
                }
            }
            
            ActiveMediaControlButton(image: "speaker.slash", imageSelected: "speaker.slash", label: "mute", selectionBinding: $dummyBinding) {
                mute.toggle()
                //apiClient.toggleMute(activeMedia.speaker!, cmd: mute)
            }
            
            
        case .monitor:
            //TODO: Binding doesnt wokr ?
            ActiveMediaControlButton(image: "power.circle", imageSelected: "power.circle.fill", label: "power", selectionBinding: $monitorPower) {
//                guard let monitor = activeMedia.monitor else { return }
                print("clicked it for", monitorPower)
                monitorPower.toggle()
                //apiClient.toggleMonitor(monitor, cmd: monitorPower)
            }
            
        case .bluetooth:
            Text("bluetooth")
        }
    }
    
    //TODO: - Make public util ? 
    private func getSourceIcon() -> String {
        let sourceType = String(describing: SourceTypes(rawValue: activeMedia.source.type)!)
        
        let iconMap: [String:SourceIcons] = [
            "appleTV" : .appleTV,
            "aux" : .aux,
            "bluray" : .bluray,
            "cabinView" : .cabinView,
            "camera" : .camera,
            "hdmi" : .hdmi,
            "kaleid" : .kaleid,
            "onDemand" : .onDemand,
            "roku" : .roku,
            "satTV" : .satTV,
            "usbC" : .usbC,
            "xm" : .xm
        ]
        
        if let iconEnum = iconMap[sourceType] {
            return iconEnum.rawValue
        } else {
            return "ic_livetv"
        }
    }
    
    private func getDeviceIcon() -> String {
        switch(device) {
        case .monitor:
            return "ic_monitor_off"
        case .speaker:
            return "ic_speaker_off"
        case .bluetooth:
            return "ic_headphones_off"
        }
    }
}
