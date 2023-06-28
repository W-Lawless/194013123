//
//  MediaOptions.swift
//  MyCabin
//
//  Created by Lawless on 5/6/23.
//

import SwiftUI

struct MediaOptions: View {
    
    @EnvironmentObject var mediaViewModel: MediaViewModel
    let mediaOptionsButtonBuilder: (String, PlaneSchematicDisplayMode) -> MediaOptionsButton
    
    var body: some View {
        
        
        VStack(spacing: 36) {
            
            if(mediaViewModel.mediaDisplayOptions == .all) {
            
                mediaOptionsButtonBuilder("display", .showMonitors)
                mediaOptionsButtonBuilder("play.display", .showNowPlaying)
                mediaOptionsButtonBuilder("speaker.wave.3", .showSpeakers)
                mediaOptionsButtonBuilder("headphones", .showBluetooth)
                mediaOptionsButtonBuilder("appletvremote.gen2", .showRemote)
                
            } else if (mediaViewModel.mediaDisplayOptions == .outputs) {
                
                mediaOptionsButtonBuilder("display", .showMonitors)
                mediaOptionsButtonBuilder("speaker.wave.3", .showSpeakers)
                mediaOptionsButtonBuilder("headphones", .showBluetooth)
                
            } else if (mediaViewModel.mediaDisplayOptions == .sound) {
                
                mediaOptionsButtonBuilder("speaker.wave.3", .showSpeakers)
                mediaOptionsButtonBuilder("headphones", .showBluetooth)
                
            }
            
        } //: VSTQ
        .padding(.trailing, 12)
    }
}

struct MediaOptionsButton: View {
  
    @EnvironmentObject var mediaViewModel: MediaViewModel

    let imageName: String
    let planeDisplayOptions: PlaneSchematicDisplayMode
    
    var body: some View {
        Button {
//            mediaViewModel.clearSelection()
//            planeViewModel.updateDisplayMode(planeDisplayOptions)
            mediaViewModel.updatePlaneDisplayOptions(planeDisplayOptions)
            mediaViewModel.updateContextualToolTip(MediaToolTips.speakers.rawValue)
//            mediaViewModel.updatePlaneDisplayOptions(planeDisplayOptions)
            
//            switch(planeViewModel.planeDisplayOptions) {
//            case .showMonitors:
//                //mediaViewModel.configForSelectMonitor() //TODO: Refactor
//                mediaViewModel.updateContextualToolTip(MediaToolTips.monitors.rawValue)
//            case .showSpeakers:
////                planeViewModel.updateDisplayMode(.showSpeakers)
//            case .showBluetooth:
////                mediaViewModel.changeViewIntent(.selectMonitorOutput)
//                mediaViewModel.updateContextualToolTip(MediaToolTips.bluetooth.rawValue)
//            case .showNowPlaying:
//                mediaViewModel.updateContextualToolTip(MediaToolTips.nowPlaying.rawValue)
//            default:
//                mediaViewModel.updateContextualToolTip(mediaViewModel.contextualToolTip)
//            }
//            
        } label: {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .frame(width: 24, height: 24)
                .overlay (
                    RoundedRectangle(cornerRadius: 6).stroke(.blue, lineWidth: 1).frame(width: 48, height: 48)
                )
        }
        .accessibilityIdentifier(imageName)
    }
}
