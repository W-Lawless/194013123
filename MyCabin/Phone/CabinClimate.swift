//
//  Climate.swift
//  MyCabin
//
//  Created by Lawless on 11/29/22.
//

import SwiftUI

struct CabinClimate: View {
    
    @ObservedObject var viewModel: CabinClimateViewModel
    var api: CabinClimateAPI
    
    func currentTemp(for c: ClimateControllerModel) -> String {
        return "\(c.state.setPoint + c.state.temp)"
    }
    
    var body: some View {
        List(viewModel.climateControllers ?? [ClimateControllerModel]()) { controller in
            Group {
                HStack {
                    Text(controller.name)
                    Text(currentTemp(for: controller))
                }
            }
        } //: LIST
        .onAppear {
            api.fetch()
        }
    }
}

class CabinClimateViewModel: ObservableObject {
    
    @Published var climateControllers: [ClimateControllerModel]?
    
    
    func updateValues(_ alive: Bool, data: [ClimateControllerModel]) {
        self.climateControllers = data
    }
    
}

//struct CabinClimate_Previews: PreviewProvider {
//    static var previews: some View {
//        CabinClimate()
//    }
//}
