//
//  Lights.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/23/22.
//

import SwiftUI

struct Lights: View {
    
    @ObservedObject var viewModel: LightsViewModel
    let planeViewBuilder: (PlaneSchematicDisplayMode) -> PlaneSchematic
    let bottomPanelBuilder: () -> LightsBottomPanel
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            planeViewBuilder(.showLights)
            
            VStack(alignment: .center) {
                if(viewModel.showPanel) {
                    bottomPanelBuilder()
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
