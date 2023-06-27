//
//  ShadeMenuPlaneDisplayOptions.swift
//  MyCabin
//
//  Created by Lawless on 6/22/23.
//

import SwiftUI

//TODO: Remove static references

struct ShadeMenuPlaneDisplayOptions: View {
    var body: some View {
        VStack(spacing: 32) {
            ShadeGroupButton(group: .all, text: "All")
            ShadeGroupButton(group: .left, text: "Left")
            ShadeGroupButton(group: .right, text: "Right")
        }
        .padding(.horizontal, 18)
    }
}


struct ShadeGroupButton: View {
  
    @EnvironmentObject var viewModel: ShadesViewModel
    let group: ShadeGroup
    let text: String
    
    var body: some View {
        Button {
            if(!viewModel.showPanel) {
                viewModel.showPanel = true
            }
            viewModel.selectAll(in: group)
        } label: {
            VStack {
                Image("ico_advanced_off")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(width: 24, height: 24)
                    .overlay (
                        RoundedRectangle(cornerRadius: 6).stroke(.blue, lineWidth: 1).frame(width: 48, height: 48)
                    )
                Text(text)
            }
        }
    }
}
