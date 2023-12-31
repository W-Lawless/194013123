//
//  Climate.swift
//  MyCabin
//
//  Created by Lawless on 11/29/22.
//

import SwiftUI

struct CabinClimate<Content: View>: View {
    
    @ObservedObject var viewModel: CabinClimateViewModel
    let planeView: () -> Content
    
    
    var body: some View {
        ZStack {
            Color("PrimaryColor")
            planeView()
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    func currentTemp(for c: ClimateControllerModel) -> String {
        return "\(c.state.setPoint + c.state.temp)"
    }
}

class CabinClimateViewModel: ObservableObject {
    
    @Published var activeZone: PlaneArea = PlaneArea(id: "", rect: RenderCoordinates(x: 0, y: 0, w: 0, h: 0, r: 0))
    @Published var showPanel: Bool = false
    @Published var climateControllers: [ClimateControllerModel]?
    
    func showSubView(forID: String) {
        
    }
    
    func updateValues(_ data: [Codable]) {
        self.climateControllers = data as? [ClimateControllerModel]
    }

}
