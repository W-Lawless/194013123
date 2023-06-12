//
//  Lights.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/23/22.
//

import SwiftUI

struct Lights: View {
    
    @ObservedObject var viewModel = StateFactory.lightsViewModel
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            PlaneFactory.buildPlaneSchematic(options: .showLights)
            
            VStack(alignment: .center) {
                if(viewModel.showPanel) {
                    LightsBottomPanel()
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            .padding(.bottom, 18)
            .background(Color.black)
            .frame(height:108, alignment: .top)
            .onAppear {
//                let endpoint = Endpoint<EndpointFormats.Get, LightModel>(path: .lights)
//                let sut = StateFactory.apiClient
//                sut.fetch(for: endpoint) { result in
//                    StateFactory.lightsViewModel.updateValues(result)
//                }
            }
            
            
        } //: ZSTQ
        .edgesIgnoringSafeArea(.bottom)
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
}


class LightsViewModel: GCMSViewModel, ParentViewModel, ObservableObject {
    
    @Published var activeSeat: String = ""
    @Published var lightList: [LightModel]?
    @Published var showPanel: Bool = false
    
    func updateValues(_ data: [Codable]) {
        let typecast = data as? [LightModel]
        if let typecast {
            self.lightList = typecast
        }
    }
    
    func showSubView(forID seat: String) {
        if(activeSeat != seat){
            showPanel = true
            activeSeat = seat
        } else {
            showPanel.toggle()
        }
    }
    
}

//MARK: - Preview

struct Lights_Previews: PreviewProvider {
    static var previews: some View {
        ViewFactory.buildLightsMenu()
    }
}


