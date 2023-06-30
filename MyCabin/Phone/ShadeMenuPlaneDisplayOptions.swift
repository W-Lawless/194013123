//
//  ShadeMenuPlaneDisplayOptions.swift
//  MyCabin
//
//  Created by Lawless on 6/22/23.
//

import SwiftUI

struct ShadeMenuPlaneDisplayOptions: View {
    var body: some View {
        VStack(spacing: 32) {
            ShadeGroupButton(group: .all, image: "arrow.left.arrow.right")
            ShadeGroupButton(group: .left, image: "arrow.left")
            ShadeGroupButton(group: .right, image: "arrow.right")
        }
        .padding(.horizontal, 18)
    }
}

//TODO: - Viewbuilder 'Plane Display Option Button' button 
struct ShadeGroupButton: View {
  
    @EnvironmentObject var viewModel: ShadesViewModel
    let group: ShadeGroup
    let image: String
    
    var body: some View {
        Button {
            if(!viewModel.showPanel) {
                viewModel.showPanel = true
            }
            viewModel.selectAll(in: group)
        } label: {
            VStack {
                Image(systemName: image)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(width: 24, height: 24)
                    .overlay (
                        RoundedRectangle(cornerRadius: 6).stroke(.blue, lineWidth: 1).frame(width: 48, height: 48)
                    )
            }
        }
    }
}
