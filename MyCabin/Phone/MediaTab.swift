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
    let planeViewBuilder: (PlaneSchematicDisplayMode) -> PlaneSchematic
    @State private var hasAppeared = false
    

    var body: some View {
        ZStack(alignment: .bottom) { // ZSTQ A
            
            ZStack(alignment: .custom) { // ZSTQ B
                
                MediaOptions(mediaViewModel: mediaViewModel)
                planeViewBuilder(mediaViewModel.planeDisplayOptions)
                
            } //:ZSTQ B
            .onAppear {
                if (!hasAppeared) {
                    mediaViewModel.changeViewIntent(.selectMonitorOutput)
                    hasAppeared = true
                }
                mediaViewModel.clearSelection()
            }
            
            
            if(mediaViewModel.displayToolTip) {
                Text(mediaViewModel.contextualToolTip)
                    .font(.headline)
                    .padding(.bottom, 48)
            }
         
            if(mediaViewModel.displaySubView) {
                mediaViewModel.contextualSubView
            }

        } //: ZSTQ A

    } //: BODY

}
