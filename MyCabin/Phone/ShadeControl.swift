//
//  ShadeControl.swift
//  MyCabin
//
//  Created by Lawless on 12/20/22.
//

import SwiftUI

struct ShadeControl: View {
    
    @ObservedObject var viewModel: ShadesViewModel = StateFactory.shadesViewModel
    @State var opened: Bool = false
    @State var sheered: Bool = false
    @State var closed: Bool = false
    
    var body: some View {
        
        HStack {
            Text(viewModel.activeShade?.id ?? "none")
            
            //-
            VStack {
                ZStack {
                    Circle()
                        .fill(opened ? Color.green : Color.black)
                        .frame(width:48, height: 50)
                        .overlay (
                            Circle()
                                .stroke(Color.white, lineWidth: 1)
                        )
                    Image(systemName: "power")
                        .foregroundColor(.white)
                }
                Text("OPEN")
                    .font(.caption2)
            }
            .frame(width: 64)
            .hapticFeedback(feedbackStyle: .rigid) { _ in
                opened = true
                sheered = false
                closed = false
                if let shade = viewModel.activeShade {
                    StateFactory.apiClient.commandShade(shade: shade, cmd: .OPEN)
                }
            } //: VSTQ

            //-
            VStack {
                ZStack {
                    Circle()
                        .fill(sheered ? Color.green : Color.black)
                        .frame(width:48, height: 50)
                        .overlay (
                            Circle()
                                .stroke(Color.white, lineWidth: 1)
                        )
                    Image(systemName: "power")
                        .foregroundColor(.white)
                }
                Text("SHEER")
                    .font(.caption2)
            }
            .frame(width: 64)
            .hapticFeedback(feedbackStyle: .rigid) { _ in
                opened = false
                sheered = true
                closed = false
                
                if let shade = viewModel.activeShade {
                    StateFactory.apiClient.commandShade(shade: shade, cmd: .OPEN)
                }
            } //: VSTQ
            

            //-
            VStack {
                ZStack {
                    Circle()
                        .fill(closed ? Color.green : Color.black)
                        .frame(width:48, height: 50)
                        .overlay (
                            Circle()
                                .stroke(Color.white, lineWidth: 1)
                        )
                    Image(systemName: "power")
                        .foregroundColor(.white)
                }
                Text("CLOSE")
                    .font(.caption2)
            }
            .frame(width: 64)
            .hapticFeedback(feedbackStyle: .rigid) { _ in
                closed = true
                opened = false
                sheered = false
                
                if let shade = viewModel.activeShade {
                    StateFactory.apiClient.commandShade(shade: shade, cmd: .OPEN)
                }
            } //: VSTQ

        } //: HSTQ
        .padding(18)
        
    } //: BODY
    
}

struct ShadeControl_Previews: PreviewProvider {
    static var previews: some View {
        ShadeControl()
            .previewLayout(.sizeThatFits)
    }
}
