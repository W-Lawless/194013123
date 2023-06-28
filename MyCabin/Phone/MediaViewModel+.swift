//
//  MediaViewModel+.swift
//  MyCabin
//
//  Created by Lawless on 6/27/23.
//

import Foundation

enum MediaDisplayOptions {
    case all
    case outputs
    case sound
}

enum MediaDevice: String {
    case monitor
    case speaker
    case bluetooth
}

enum MediaViewIntent: String, Equatable {
    case selectMonitorOutput
    case selectSpeakerOutput
    case viewNowPlaying
    
    static func == (lhs: MediaViewIntent, rhs: MediaViewIntent) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

enum MediaToolTips: String {
    case monitors = "Select a monitor output:"
    case speakers = "Select a speaker output:"
    case bluetooth = "Select a bluetooth device:"
    case nowPlaying = "Currently playing media:"
}

struct ActiveMedia: Equatable, Hashable, Codable {
    var id = UUID()
    var source: SourceModel
    var monitor: MonitorModel?
    var speaker: SpeakerModel?
    var bluetooth: String?
    
    static func == (lhs: ActiveMedia, rhs: ActiveMedia) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}
