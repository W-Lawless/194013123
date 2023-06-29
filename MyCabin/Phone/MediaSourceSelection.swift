//
//  MediaSourceSelection.swift
//  MyCabin
//
//  Created by Lawless on 5/9/23.
//

import SwiftUI

struct MediaSourceSelection: View {
    
    let sourcesHScrollBuilder: () -> SourcesHorizontalScroll
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("Select a source.")
                .font(.headline)
                .padding(.leading, 8)
            
            ScrollViewReader { value in
                
                ScrollView(.horizontal) {
                    sourcesHScrollBuilder()
                } //:SCRLL
                .frame(height: 96)
                .padding(.bottom, 14)
                .onAppear {
                    value.scrollTo(SourceTypes.camera, anchor: .center)
                }
                
            } //: SCRLLREADR
            
        } //: VSTQ
    }
}
