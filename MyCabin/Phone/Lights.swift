//
//  Lights.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/23/22.
//

//TODO: -- Light Zones glichts while panel is open,
//TODO: -- Light ZOne group command

import SwiftUI

struct Lights<LightControlPanel: View, PlaneView: View>: View {
    
    @ObservedObject var viewModel: LightsViewModel
    let bottomPanel: () -> LightControlPanel
    let planeView: () -> PlaneView
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            Color("PrimaryColor")
            
            planeView()
            
            VStack(alignment: .center) {
                if(viewModel.showPanel) {
                    bottomPanel()
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            .padding(.bottom, 18)
            .background(Color.black)
            .frame(height:108, alignment: .top)
            
        } //: ZSTQ
        .environmentObject(viewModel)
        .edgesIgnoringSafeArea(.bottom)
    }
        
}

//MARK: - Gestures
//    var dragGesture: some Gesture {
//        DragGesture()
//            .onEnded { value in
//                let begins = value.startLocation.x
//                let ends = value.location.x
//
//                if( (ends - begins) > 100 ) {
//                    print("navigate back")
//                    navigation.popView()
//                }
//            }
//    }
