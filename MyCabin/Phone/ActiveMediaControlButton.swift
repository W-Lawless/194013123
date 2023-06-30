//
//  ActiveMediaControlButton.swift
//  MyCabin
//
//  Created by Lawless on 6/29/23.
//

import SwiftUI

struct ActiveMediaControlButton: View {
    
    let image: String
    let imageSelected: String
    let label: String
    @Binding var selectionBinding: Bool
    let callback: () -> ()
    
    var body: some View {
        VStack {
            Image(systemName: image)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 48, maxHeight: 48)
            Text(label)
        }
        .frame(width: 88, height: 88)
        .overlay (
            RoundedRectangle(cornerRadius: 8).stroke(.blue, lineWidth: 1).frame(width: 86, height: 86)
        )
        .hapticFeedback(feedbackStyle: .light) { _ in
            callback()
        }
    }
}
