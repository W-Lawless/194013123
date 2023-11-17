//
//  Media.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/9/22.
//

import SwiftUI
import Combine

struct MediaTab<Plane: View, BottomPanel: View>: View {
    
    @ObservedObject var mediaViewModel: MediaViewModel
    @ObservedObject var activeMediaViewModel: ActiveMediaViewModel
    
    let planeView: () -> Plane
    let bottomPanel: () -> BottomPanel //TODO: - viewbuilder here
    
    var body: some View {
        ZStack(alignment: .bottom) { // ZSTQ A
            
            Color("PrimaryColor")
            
            planeView()

            if(mediaViewModel.displayToolTip) {
                Text(mediaViewModel.contextualToolTip)
                    .font(.headline)
                    .padding(.bottom, 48)
            }
         
            if(mediaViewModel.displaySubView) {
                bottomPanel()
            }

        } //: ZSTQ A
        .environmentObject(activeMediaViewModel)
        .environmentObject(mediaViewModel)
        .onAppear {
            mediaViewModel.clearMediaSelection()
        }
        .edgesIgnoringSafeArea(.top)
        
    } //: BODY

}
