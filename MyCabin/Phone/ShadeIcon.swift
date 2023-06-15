//
//  ShadeIcon.swift
//  MyCabin
//
//  Created by Lawless on 5/3/23.
//

import SwiftUI

struct ShadeButton: View {
    
    @ObservedObject var viewModel: ShadesViewModel = StateFactory.shadesViewModel
    var shade: ShadeModel
    
    var body: some View {
        Image(viewModel.activeShades.contains(where: { selected in
            return selected.id == shade.id
        }) ? "windows_selected" : "windows_selectable")
                .resizable()
                .scaledToFit()
                .frame(width:21, height: 44)
                .hapticFeedback(feedbackStyle: .light) { _ in
//                    viewModel.appendShade(shade)
                    viewModel.selectShade(is: shade.id)
                    if(viewModel.selectedShade != viewModel.activeShade?.id) {
                        viewModel.activeShade = shade
                    } else {
                        viewModel.showPanel.toggle()
                    }
                } //: HAPTIC

    }
}

//struct ShadeIcon_Previews: PreviewProvider {
//    static var previews: some View {
//        ShadeIcon()
//    }
//}
