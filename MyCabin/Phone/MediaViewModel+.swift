//
//  MediaViewModel+.swift
//  MyCabin
//
//  Created by Lawless on 6/27/23.
//

import Foundation

enum MediaViewIntent: String, Equatable {
    case noActiveMedia
    case selectMonitorOutput
    case selectSpeakerOutput
    case pairSpeakerWithMonitor
//    case pairBluetoothWithMonitor
    case pairMonitorWithSpeaker
//    case pairSpeakerWithMonitor
    
    case viewNowPlaying
    //case changeActiveMediaSource
    //case selectBluetoothOutput
    //case viewRemote
    
    static func == (lhs: MediaViewIntent, rhs: MediaViewIntent) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

enum MediaDisplayOptions {
    case all
    case outputs
    case sound
    case onlyVisible
}

enum MediaDevice: String {
    case monitor
    case speaker
    case bluetooth
}

protocol MediaDeviceModel {
    var id: String { get set  }
    var rect: RenderCoordinates { get set }
}


enum MediaToolTips: String {
    case monitors = "Select output monitor(s):"
    case speakers = "Select output speaker(s):"
    case bluetooth = "Select output bluetooth device(s):"
    case nowPlaying = "Currently playing media:"
}


