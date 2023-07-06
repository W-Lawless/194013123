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
                
            } else if (mediaViewModel.mediaDisplayOptions == .onlyVisible) {
                
                EmptyView()
                
            }
            
        } //: VSTQ
        .padding(.trailing, 12)
    }
}

//TODO: - Viewbuilder 'Plane Display Option Button' button
struct MediaOptionsButton: View {
  
    @EnvironmentObject var mediaViewModel: MediaViewModel

    let imageName: String
    let planeDisplayOptions: PlaneSchematicDisplayMode
    
    var body: some View {
        Button {
            mediaViewModel.clearMediaSelection()
            mediaViewModel.updateContextualToolTip(planeDisplayOptions)
            mediaViewModel.updatePlaneDisplayOptions(planeDisplayOptions)
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
