//
//  ActiveMediaButton.swift
//  MyCabin
//
//  Created by Lawless on 5/9/23.
//

import SwiftUI

//TODO: Remove static references

struct ActiveMediaButton: View {
    
    @EnvironmentObject var mediaViewModel: MediaViewModel

    let area: PlaneArea
    let activeMedia: ActiveMedia
    
    var body: some View {
        if let speaker = activeMedia.speaker {
            if ( speakerInArea() ) {
                Image(assetUrl(activeMedia.source, device: .speaker))
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 48, maxHeight: 48)
                    .accessibilityIdentifier("active_\(speaker.id)")
                    .hapticFeedback(feedbackStyle: .light, cb: mediaViewModel.activeSpeakerIconCallback, cbArgs: activeMedia)
                    .modifier(PlaceIcon(rect: speaker.rect))
            }
        }

        if let monitor = activeMedia.monitor {
            if ( monitorInArea() ) {
                Image(assetUrl(activeMedia.source, device: .monitor))
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 48, maxHeight: 48)
                    .accessibilityIdentifier("active_\(monitor.id)")
                    .hapticFeedback(feedbackStyle: .light, cb: mediaViewModel.activeMonitorIconCallback, cbArgs: activeMedia)
                    .modifier(PlaceIcon(rect: monitor.rect))
            }
        }
    }
    
    private func speakerInArea() -> Bool {
        
        guard let areaSpeakers = area.speakers  else { return false }
        guard let speaker = activeMedia.speaker else { return false }

        let allSpeakerIDs = areaSpeakers.map {
            $0.id
        }
            
        if ( allSpeakerIDs.contains(speaker.id) ) {
            return true
        } else {
            return false
        }
            
    }
    
    private func monitorInArea() -> Bool {
        
        guard let areaMonitors = area.monitors  else { return false }
        guard let monitor = activeMedia.monitor  else { return false }
        
        let allMonitorIDs = areaMonitors.map {
            $0.id
        }
        
        if ( allMonitorIDs.contains(monitor.id) ) {
            return true
        } else {
            return false
        }
        
    }
    
    private func assetUrl(_ source: SourceModel, device: MediaDevice) -> String {
        switch (source.type) {
        case SourceTypes.aux.rawValue:
            return ActiveMediaIcons.aux.icon(device: device)
        case SourceTypes.appleTV.rawValue:
            return ActiveMediaIcons.appletv.icon(device: device)
        case SourceTypes.bluray.rawValue:
            return ActiveMediaIcons.bluray.icon(device: device)
        case SourceTypes.cabinView.rawValue:
            return ActiveMediaIcons.cabinview.icon(device: device)
        case SourceTypes.camera.rawValue:
            return ActiveMediaIcons.camera.icon(device: device)
        case SourceTypes.hdmi.rawValue:
            return ActiveMediaIcons.hdmi.icon(device: device)
        case SourceTypes.kaleid.rawValue:
            return ActiveMediaIcons.kaleid.icon(device: device)
        case SourceTypes.onDemand.rawValue:
            return ActiveMediaIcons.aux.icon(device: device)
        case SourceTypes.roku.rawValue:
            return ActiveMediaIcons.aux.icon(device: device)
        case SourceTypes.satTV.rawValue:
            return ActiveMediaIcons.satTV.icon(device: device)
        case SourceTypes.usbC.rawValue:
            return ActiveMediaIcons.aux.icon(device: device)
        case SourceTypes.xm.rawValue:
            return ActiveMediaIcons.aux.icon(device: device)
        default:
            return "ic_monitor_on"
        }
    }

    private enum ActiveMediaIcons {
        case appletv
        case bluray
        case cabinview
        case camera
        case hdmi
        case kaleid
        case satTV
        case aux
        
        func icon(device: MediaDevice) -> String {
            switch (device) {
            case .monitor:
                switch (self) {
                case .appletv:
                    return "btn_apple_tv_monitor_playing"
                case .bluray:
                    return "btn_blu_ray_monitor_playing"
                case .cabinview:
                    return "btn_cabinview_monitor_playing"
                case .camera:
                    return "btn_cameras_monitor_playing"
                case .hdmi:
                    return "btn_hdmi_monitor_playing"
                case .kaleid:
                    return "btn_kaleidescape_monitor_playing"
                case .satTV:
                    return "btn_livetv_monitor_playing"
                case .aux:
                    return "ic_monitor_on"
                }
            case .speaker:
                switch (self) {
                case .appletv:
                    return "btn_apple_tv_speaker_playing"
                case .bluray:
                    return "btn_blu_ray_speaker_playing"
                case .cabinview:
                    return "btn_cabinview_speaker_playing"
                case .camera:
                    return "btn_cameras_speaker_playing"
                case .hdmi:
                    return "btn_hdmi_speaker_playing"
                case .kaleid:
                    return "btn_kaleidescape_speaker_playing"
                case .satTV:
                    return "btn_livetv_speaker_playing"
                case .aux:
                    return "ic_speaker_on"
                }
            case .bluetooth:
                switch (self) {
                case .appletv:
                    return "btn_apple_tv_headphones_playing"
                case .bluray:
                    return "btn_blu_ray_headphones_playing"
                case .cabinview:
                    return "btn_cabinview_headphones_playing"
                case .camera:
                    return "btn_cameras_headphones_playing"
                case .hdmi:
                    return "btn_hdmi_headphones_playing"
                case .kaleid:
                    return "btn_kaleidescape_headphones_playing"
                case .satTV:
                    return "btn_livetv_headphones_playing"
                case .aux:
                    return "ic_headphones_on"
                }
            }
        }
    }
}

//struct ActiveMediaButton_Previews: PreviewProvider {
//    static var previews: some View {
//        ActiveMediaButton()
//    }
//}




