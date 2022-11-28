//
//  Lights.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/23/22.
//

import SwiftUI

struct Lights: View {
    
    @StateObject var viewModel: LightsViewModel
    var api: LightsAPI
    @State var luminosity: Int = 0
        
    var body: some View {
        
//        LightControl()
        
        TabView{

            List(viewModel.lightList ?? [LightModel]()) { light in
                
                Button("ON \(light.id)") {
                    api.toggleLight(light, cmd: .ON)
                }
                
                Button("OFF \(light.id)") {
                    api.toggleLight(light, cmd: .OFF)
                }
                
                Stepper("Brightness", value: $luminosity)
                
            }//: LIST
        }
        .tabViewStyle(.page)
        .onAppear {
            api.fetch()
        } //: TABVIEW
        
    }
}

//MARK: - View Model

class LightsViewModel: ObservableObject {
    
    @Published var loading: Bool = true
    @Published var lightList: [LightModel]?
    
    func updateValues(_ alive: Bool, _ data: [LightModel]?) {
        self.loading = !alive
        if let data = data {
            self.lightList = data
        }
    }
    
}

//MARK: - Preview

struct Lights_Previews: PreviewProvider {
    static var previews: some View {
        ViewFactories.buildLightsView()
    }
}


