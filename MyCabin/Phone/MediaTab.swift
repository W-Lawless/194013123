//
//  Media.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/9/22.
//

import SwiftUI
import Combine

struct MediaTab: View {
    
//    @ObservedObject var planeViewModel: PlaneViewModel
    @ObservedObject var mediaViewModel: MediaViewModel
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
        .environmentObject(mediaViewModel)
        .onAppear {
//            planeViewModel.updateDisplayMode(.showMonitors)
            mediaViewModel.clearSelection()
        }
        
        
        
    } //: BODY

}
