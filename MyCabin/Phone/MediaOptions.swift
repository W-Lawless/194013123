//
//  MediaOptions.swift
//  MyCabin
//
//  Created by Lawless on 5/6/23.
//

import SwiftUI

struct MediaOptions: View {
    
    @ObservedObject var mediaViewModel: MediaViewModel
    
    var body: some View {
        
        
        VStack(spacing: 36) {
            
            if(mediaViewModel.mediaDisplayOptions == .all) {
            
                OptionsButton(mediaViewModel: mediaViewModel, imageName: "display", planeDisplayOptions: .showMonitors)
                OptionsButton(mediaViewModel: mediaViewModel, imageName: "play.display", planeDisplayOptions: .showNowPlaying)
                OptionsButton(mediaViewModel: mediaViewModel, imageName: "speaker.wave.3", planeDisplayOptions: .showSpeakers)
                OptionsButton(mediaViewModel: mediaViewModel, imageName: "headphones", planeDisplayOptions: .showBluetooth)
                OptionsButton(mediaViewModel: mediaViewModel, imageName: "appletvremote.gen2", planeDisplayOptions: .showRemote)
                
            } else if (mediaViewModel.mediaDisplayOptions == .outputs) {
                
                OptionsButton(mediaViewModel: mediaViewModel, imageName: "display", planeDisplayOptions: .showMonitors)
                OptionsButton(mediaViewModel: mediaViewModel, imageName: "speaker.wave.3", planeDisplayOptions: .showSpeakers)
                OptionsButton(mediaViewModel: mediaViewModel, imageName: "headphones", planeDisplayOptions: .showBluetooth)
                
            } else if (mediaViewModel.mediaDisplayOptions == .sound) {
                
                OptionsButton(mediaViewModel: mediaViewModel, imageName: "speaker.wave.3", planeDisplayOptions: .showSpeakers)
                OptionsButton(mediaViewModel: mediaViewModel, imageName: "headphones", planeDisplayOptions: .showBluetooth)
                
            }
            
        } //: VSTQ
        .padding(32)
    }
}

struct OptionsButton: View {
  
    @ObservedObject var mediaViewModel: MediaViewModel

    let imageName: String
    let planeDisplayOptions: PlaneSchematicDisplayMode
    
    var body: some View {
        Button {
            mediaViewModel.clearSelection()
            mediaViewModel.updatePlaneDisplayOptions(planeDisplayOptions)
            
            switch(mediaViewModel.planeDisplayOptions) {
            case .showMonitors:
                mediaViewModel.configForSelectMonitor()
            case .showSpeakers:
                mediaViewModel.speakerIconCallback = mediaViewModel.selectSpeaker
                mediaViewModel.updateContextualToolTip(MediaToolTips.speakers.rawValue)
            case .showBluetooth:
                mediaViewModel.updateContextualToolTip(MediaToolTips.bluetooth.rawValue)
            case .showNowPlaying:
                mediaViewModel.updateContextualToolTip(MediaToolTips.nowPlaying.rawValue)
            default:
                mediaViewModel.updateContextualToolTip(mediaViewModel.contextualToolTip)
            }
            
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
