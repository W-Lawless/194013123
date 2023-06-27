//
//  ActiveMediaControlPanel.swift
//  MyCabin
//
//  Created by Lawless on 5/9/23.
//

import SwiftUI

//TODO: - remove static reference
struct ActiveMediaControlPanel: View {
    
    @ObservedObject var mediaViewModel: MediaViewModel
    let activeMedia: ActiveMedia
    let device: MediaDevice
    @State var mute: Bool = false
    @State var volume: Int = 25
    
    @State var monitorPower: Bool = true

    
    var body: some View {
        
        
        GeometryReader { geo in
            
            ScrollView(.horizontal) {
                
                HStack(spacing: 24) {
                    
                        Image(getDeviceIcon())
                            .resizable()
                            .scaledToFit()
                            .frame(width: 64, height: 64)
                            .accessibilityIdentifier("active_device_\(device.rawValue)")

                    Button {} label: {
                        VStack(spacing: 4) {
                            Image(systemName: "power.off")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 48, height: 48)
                                .accessibilityIdentifier("source_icon_\(activeMedia.source.id)")
                            Text("delete_it")
                                .foregroundColor(.white)
                                .font(.system(size: 11))
                        } //: VSTQ
                        .frame(width: 88, height: 88)
                        .overlay (
                            RoundedRectangle(cornerRadius: 8).stroke(.blue, lineWidth: 1).frame(width: 86, height: 86)
                        )
                        .hapticFeedback(feedbackStyle: .medium) { _ in
                            mediaViewModel.displaySubView.toggle()
                            mediaViewModel.contextualSubView = AnyView(ViewFactory.buildSourcesView())
                            mediaViewModel.displaySubView.toggle()
                        }
                        
                    } //: BTN
                    
                        Button {} label: {
                            VStack(spacing: 4) {
                                Image(getSourceIcon())
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 48, height: 48)
                                    .accessibilityIdentifier("source_icon_\(activeMedia.source.id)")
                                Text(activeMedia.source.name)
                                    .foregroundColor(.white)
                                    .font(.system(size: 11))
                            } //: VSTQ
                            .frame(width: 88, height: 88)
                            .overlay (
                                RoundedRectangle(cornerRadius: 8).stroke(.blue, lineWidth: 1).frame(width: 86, height: 86)
                            )
                            .hapticFeedback(feedbackStyle: .medium) { _ in
                                NavigationFactory.rootTabCoordinator.goTo(.sourceList)
                            }
                            
                        } //: BTN
                    
                    
                    switch(device) {
                    case .speaker:
                        Image(systemName: "speaker.plus")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 48, maxHeight: 48)
                            .hapticFeedback(feedbackStyle: .light) { _ in
                                if (volume < 100) {
                                    volume = volume + 5
                                    print(volume)
                                    StateFactory.apiClient.setVolume(activeMedia.speaker!, volume: volume)
                                }
                            }
                        
                        Image(systemName: "speaker.minus")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 48, maxHeight: 48)
                            .hapticFeedback(feedbackStyle: .light) { _ in
                                if(volume > 0) {
                                    volume = volume - 5
                                    print(volume)
                                    StateFactory.apiClient.setVolume(activeMedia.speaker!, volume: volume)
                                }
                            }
                                                
                        Image(systemName: "speaker.slash")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 48, maxHeight: 48)
                            .hapticFeedback(feedbackStyle: .light) { _ in
                                mute.toggle()
                                StateFactory.apiClient.toggleMute(activeMedia.speaker!, cmd: mute)
                            }
                        
                    case .monitor:
                        
                        Button {} label: {
                            VStack(spacing: 4) {
                                Image(systemName: monitorPower ? "power.circle.fill" : "power.circle" )
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: 48, maxHeight: 48)
                                Text("Power")
                                    .foregroundColor(.white)
                                    .font(.system(size: 11))
                            } //: VSTQ
                            .frame(width: 88, height: 88)
                            .overlay (
                                RoundedRectangle(cornerRadius: 8).stroke(.blue, lineWidth: 1).frame(width: 86, height: 86)
                            )
                            .hapticFeedback(feedbackStyle: .medium) { _ in
                                
                                guard let monitor = activeMedia.monitor else { return }
                                monitorPower.toggle()
                                StateFactory.apiClient.toggleMonitor(monitor, cmd: monitorPower)
                                
                            }
                            
                        } //: BTN
                        
                    case .bluetooth:
                        Text("bluetooth")
                    }

                    
                } //:HSTQ
                .padding(.horizontal, (geo.size.width * 0.08))
                
                
            } //: SCRLL
            
        } //: GEO
        .frame(height: 108)
        .border(.red, width: 1)
    
        
    }
    
    private func getSourceIcon() -> String {
        let sourceType = String(describing: SourceTypes(rawValue: activeMedia.source.type)!)
        print("source type enum case is", sourceType)

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
        print(device)
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

