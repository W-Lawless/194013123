//
//  Climate.swift
//  MyCabin
//
//  Created by Lawless on 11/29/22.
//

import SwiftUI

struct CabinClimate: View {
    
    @ObservedObject var viewModel: CabinClimateViewModel
    
    func currentTemp(for c: ClimateControllerModel) -> String {
        return "\(c.state.setPoint + c.state.temp)"
    }
    
    var body: some View {
        PlaneFactory.buildPlaneSchematic(topLevelViewModel: viewModel, options: PlaneSchematicDisplayMode.tempZones)

//        List(viewModel.climateControllers ?? [ClimateControllerModel]()) { controller in
//            Group {
//                HStack {
//                    Text(controller.name)
//                    Text(currentTemp(for: controller))
//                }
//            }
//        } //: LIST
    }
}

class CabinClimateViewModel: ObservableObject, GCMSViewModel, ParentViewModel {
    
    @Published var activeZone: PlaneArea = PlaneArea(id: "", rect: RenderCoordinates(x: 0, y: 0, w: 0, h: 0, r: 0))
    @Published var showPanel: Bool = false
    
    func showSubView(forID: String) {
        
    }
    
    @Published var climateControllers: [ClimateControllerModel]?
    
    func updateValues(_ data: [Codable]) {
        self.climateControllers = data as? [ClimateControllerModel]
    }

}

//struct CabinClimate_Previews: PreviewProvider {
//    static var previews: some View {
//        CabinClimate()
//    }
//}
