//
//  ActiveMediaViewModel+.swift
//  MyCabin
//
//  Created by Lawless on 6/28/23.
//

import Foundation

struct ActiveMedia: Equatable, Hashable, Codable {
    var id = UUID()
    var source: SourceModel = SourceModel()
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
