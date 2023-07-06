//
//  Sources.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/28/22.
//

import SwiftUI

struct SourcesHorizontalScroll: View {
    
    @ObservedObject var viewModel: MediaViewModel
    
    let sourceIconCallback: (SourceType) -> ()
    
    var body: some View {
        HStack(spacing:10) {
            
            ForEach(viewModel.sourceTypes, id: \.id) { sourceType in
                
                SourceSelectionButton(image: sourceType.icon.rawValue, label: sourceType.name, uilabel: sourceType.id.rawValue)
                .hapticFeedback(feedbackStyle: .medium) { _ in
                    sourceIconCallback(sourceType)
                }
                
            } //: FOREACH
            
        } //: HSTQ
        .padding(.horizontal, 8)
        
    }

}


struct SourceSelectionButton: View {
    
    let image: String
    let label: String
    let uilabel: String
    var sysimg: Bool = false
    
    var body: some View {
        VStack(spacing: 4) {
            if (!sysimg) {
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48, height: 48)
            } else {
                Image(systemName: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48, height: 48)
            }
            Text(label)
                .foregroundColor(.white)
                .font(.system(size: 11))
        } //: VSTQ
        .frame(width: 88, height: 88)
        .overlay (
            RoundedRectangle(cornerRadius: 8).stroke(.blue, lineWidth: 1).frame(width: 86, height: 86)
        )
        .accessibilityIdentifier(uilabel)
    }
    
}
