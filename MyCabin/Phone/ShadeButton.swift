//
//  ShadeIcon.swift
//  MyCabin
//
//  Created by Lawless on 5/3/23.
//

import SwiftUI

struct ShadeButton: View {
    
    @ObservedObject var viewModel: ShadesViewModel
    var shade: ShadeModel
    
    var body: some View {
        Image(viewModel.activeShades.contains(where: { selected in
            return selected.id == shade.id
        }) ? "windows_selected" : "windows_selectable")
                .resizable()
                .scaledToFit()
                .frame(width:21, height: 44)
                .accessibilityIdentifier(shade.id)
                .hapticFeedback(feedbackStyle: .light) { _ in
                    viewModel.selectShade(shade)
                } //: HAPTIC
    }
}
