//
//  Media.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/9/22.
//

import SwiftUI
import Combine

struct MediaTab: View {
    
    @StateObject var mediaViewModel: MediaViewModel
    @State private var hasAppeared = false

    var body: some View {
        ZStack(alignment: .bottom) {
            
            ZStack(alignment: .custom) {
                
                MediaOptions(mediaViewModel: mediaViewModel)
                    
                PlaneFactory.buildPlaneSchematic(options: mediaViewModel.planeDisplayOptions)
                
            } //:ZSTQ
            .onAppear {
                
                if (!hasAppeared) {
                    if mediaViewModel.mediaViewIntent == nil {
                        mediaViewModel.changeViewIntent(.selectMonitorOutput)
                    }
                }
                hasAppeared = true
                
                mediaViewModel.clearSelection()
            }
            
            
            if(mediaViewModel.displayToolTip) {
                Text(mediaViewModel.contextualToolTip)
                    .font(.headline)
                    .padding(.bottom, 48)
            }
         
            if(mediaViewModel.displaySubView) {
                mediaViewModel.contextualSubView
            } //: CONDITIONAL

        } //: ZSTQ

    } //: BODY

}


struct Media_Previews: PreviewProvider {
    static var previews: some View {
        MediaTab(mediaViewModel: StateFactory.mediaViewModel)
    }
}


//MARK: - Custom Alignment


extension HorizontalAlignment {
    enum Custom: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            d[HorizontalAlignment.trailing]
        }
    }
    static let custom = HorizontalAlignment(Custom.self)
}
extension VerticalAlignment {
    enum Custom: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            d[VerticalAlignment.center]
        }
    }
    static let custom = VerticalAlignment(Custom.self)
}
extension Alignment {
    static let custom = Alignment(horizontal: .custom,
                                  vertical: .custom)
}
