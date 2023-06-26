//
//  ShadeControl.swift
//  MyCabin
//
//  Created by Lawless on 12/20/22.
//

import SwiftUI

//TODO: Remove static references
struct ShadeControl: View {
    
    @ObservedObject var viewModel: ShadesViewModel = StateFactory.shadesViewModel
    @State private var iconState: OSC = .none
    
    var body: some View {
        
        HStack {
            Text(viewModel.activeShade?.id ?? "none")
                .font(.caption)
            
            //-
            VStack {
                ZStack {
                    Circle()
                        .fill(iconState == .opened ? Color.green : Color.black)
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
                iconState = .opened
                
                if let shade = viewModel.activeShade {
                    StateFactory.apiClient.commandShade(shade: shade, cmd: .OPEN)
                }
            } //: VSTQ

            //-
            VStack {
                ZStack {
                    Circle()
                        .fill(iconState == .sheer ? Color.green : Color.black)
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
                iconState = .sheer
                
                if let shade = viewModel.activeShade {
                    StateFactory.apiClient.commandShade(shade: shade, cmd: .OPEN)
                }
            } //: VSTQ
            

            //-
            VStack {
                ZStack {
                    Circle()
                        .fill(iconState == .closed ? Color.green : Color.black)
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
                iconState = .closed
                
                if let shade = viewModel.activeShade {
                    StateFactory.apiClient.commandShade(shade: shade, cmd: .OPEN)
                }
            } //: VSTQ

        } //: HSTQ
        .padding(18)
        
    } //: BODY
    
    private enum OSC {
        case opened
        case sheer
        case closed
        case none
    }
    
}

struct ShadeControl_Previews: PreviewProvider {
    static var previews: some View {
        ShadeControl()
            .previewLayout(.sizeThatFits)
    }
}
