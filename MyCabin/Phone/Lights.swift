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
    
    typealias F = EndpointFormats.Get
    typealias R = LightModel.state
    
    @Published var activeSeat: String = ""
    @Published var lightList: [LightModel]?
    @Published var showPanel: Bool = false
    @Published var rtResponses = [String:R]()
    @Published var lightsForSeat = [LightModel]()
    let getLights: (String) -> [LightModel]
    
    var rtAPI = [RealtimeAPI<F ,R>]()
    
    init(getLights: @escaping (String) -> [LightModel]) {
        self.getLights = getLights
    }
    
    func updateValues(_ data: [Codable]) {
        let typecast = data as? [LightModel]
        if let typecast {
            self.lightList = typecast
        }
    }
    
    func getLightsForSeat() {
        self.lightsForSeat = getLights(activeSeat)
//        let target = PlaneFactory.planeViewModel.plane.allSeats.filter { seat in
//            return seat.id == activeSeat
//        }
//
//        if let seatLights = target.first?.lights {
//            lightsForSeat = seatLights
//        }
    }
    
    func showSubView(forID seat: String) {
        if(activeSeat != seat){
            showPanel = true
            activeSeat = seat
        } else {
            showPanel.toggle()
        }
    }
    
    
    func pollLightsForState(lights: [LightModel]) {
        lights.forEach { light in
            let ep = Endpoint<F, R>(path: .lights, stateUpdate: light.id)
            let pointer =  RealtimeAPI(endpoint: ep, callback: { [weak self] apiResult in
                if let state = apiResult.first {
                    self?.rtResponses[light.id] = state
                }
            })
            rtAPI.append(pointer)
            pointer.monitor.startMonitor(interval: 1.0, callback: pointer.monitorCallback)
        }
    }
    
    func killMonitor() {
        print("KILL MONITOR!")
        self.rtAPI.forEach({ api in
            api.monitor.stopMonitor()
        })
    }
    
    
    
}
