//
//  ActiveMediaButton.swift
//  MyCabin
//
//  Created by Lawless on 5/9/23.
//

import SwiftUI

struct ActiveMediaButtonGroup: View {
    
    @EnvironmentObject var mediaViewModel: MediaViewModel

    let activeMedia: ActiveMedia
    let speakers: [SpeakerModel]
    let monitors: [MonitorModel]
    let activeMediaDeviceButtonBuilder: (ActiveMedia, MediaDeviceModel, MediaDevice) -> ActiveMediaDeviceButton
    
    var body: some View {

        ForEach(speakers, id: \.id) { speaker in
            activeMediaDeviceButtonBuilder(activeMedia, speaker, .speaker)
        }

        ForEach(monitors, id: \.id) { monitor in
            activeMediaDeviceButtonBuilder(activeMedia, monitor, .monitor)
        }
        
        //TODO: - Bluetooth
//        ForEach(monitors, id: \.id) { monitor in
//            activeMediaDeviceButtonBuilder(activeMedia.source, .monitor, monitor)
//        }

    }

}
