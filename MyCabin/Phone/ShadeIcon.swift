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
        Image(viewModel.activeShade == shade && viewModel.showPanel ? "windows_selected" : "windows_selectable")
                .resizable()
                .scaledToFit()
                .frame(width:21, height: 44)
                .hapticFeedback(feedbackStyle: .light) { _ in
                    viewModel.selectShade(is: shade.id)
                    if(viewModel.selectedShade != viewModel.activeShade?.id) {
                        viewModel.activeShade = shade
                    } else {
                        viewModel.showPanel.toggle()
                    }
                }

    }
}

//struct ShadeIcon_Previews: PreviewProvider {
//    static var previews: some View {
//        ShadeIcon()
//    }
//}
