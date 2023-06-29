//
//  ActiveMediaIcons.swift
//  MyCabin
//
//  Created by Lawless on 6/28/23.
//

import Foundation

enum ActiveMediaIcons {
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
