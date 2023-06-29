//
//  Media.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/9/22.
//

import SwiftUI
import Combine

struct MediaTab: View {
    
    @ObservedObject var mediaViewModel: MediaViewModel
    @ObservedObject var activeMediaViewModel: ActiveMediaViewModel
    
    let planeViewBuilder: (PlaneSchematicDisplayMode) -> PlaneSchematic
    let mediaSubViewBuilder: () -> AnyView
    
    var body: some View {
        ZStack(alignment: .bottom) { // ZSTQ A
            
            planeViewBuilder(mediaViewModel.planeDisplayOptions)

            if(mediaViewModel.displayToolTip) {
                Text(mediaViewModel.contextualToolTip)
                    .font(.headline)
                    .padding(.bottom, 48)
            }
         
            if(mediaViewModel.displaySubView) {
                mediaSubViewBuilder()
            }

        } //: ZSTQ A
        .environmentObject(activeMediaViewModel)
        .environmentObject(mediaViewModel)
        .onAppear {
            mediaViewModel.clearMediaSelection()
        }
        
    } //: BODY

}
