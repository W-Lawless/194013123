//
//  ShadeControl.swift
//  MyCabin
//
//  Created by Lawless on 12/20/22.
//

import SwiftUI

struct ShadeControl: View {
    
    @EnvironmentObject var viewModel: ShadesViewModel
    @State private var iconState: ShadeStates = .NONE
    
    let buttonCallback: (ShadeStates) -> ()
 
    var body: some View {
        GeometryReader { geo in

            HStack(alignment: .center) {
                ShadeControlButton(currentState: $iconState, stateRepresented: .OPEN, imageName: "power", label: "OPEN", buttonCallback: buttonCallback)
                ShadeControlButton(currentState: $iconState, stateRepresented: .SHEER, imageName: "power", label: "SHEER", buttonCallback: buttonCallback)
                ShadeControlButton(currentState: $iconState, stateRepresented: .CLOSE, imageName: "power", label: "CLOSE", buttonCallback: buttonCallback)
            }
            .padding(.top, 12)
            .frame(width: geo.size.width)
            
        }

        
    } //: BODY
    
}


//TODO: - Componentize Control Button
//TODO: - viewbuilder

struct ShadeControlButton: View {
    
    @Binding var currentState: ShadeStates
    var stateRepresented: ShadeStates
    let imageName: String
    let label: String
    
    let buttonCallback: (ShadeStates) -> ()
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(currentState == stateRepresented ? Color.green : Color.black)
                    .frame(width:48, height: 50)
                    .overlay (
                        Circle()
                            .stroke(Color.white, lineWidth: 1)
                    )
                Image(systemName: imageName)
                    .foregroundColor(.white)
            }
            Text(label)
                .font(.caption2)
        }
        .frame(width: 64)
        .hapticFeedback(feedbackStyle: .rigid) { _ in
            currentState = stateRepresented
            buttonCallback(stateRepresented)
        } //: VSTQ
    }
}
