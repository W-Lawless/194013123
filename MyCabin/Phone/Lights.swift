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
    var navigation: HomeMenuCoordinator
    @State var luminosity: Int = 0
//    @State var location: CGPoint = CGPoint(x: 0, y: 0)
        
    var body: some View {
        
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
        }  //: TABVIEW
        .tabViewStyle(.page)
        .onAppear {
//            api.fetch()
//            let cachedLights = CacheUtil.cache.object(forKey: "Lights") as? StructWrapper<[LightModel]>
//            if let cachedLights = cachedLights {
//                print("unwrapped:", cachedLights)
//            }
        }
        .gesture(dragGesture)
    }
    
    //MARK: - Gestures
    
    var dragGesture: some Gesture {
        DragGesture()
            .onEnded { value in
                let begins = value.startLocation.x
                let ends = value.location.x
                
                if( (ends - begins) > 100 ) {
                    print("navigate back")
                    navigation.popView()
                }
            }
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

//struct Lights_Previews: PreviewProvider {
//    static var previews: some View {
//        AppFactory.buildLightsView()
//    }
//}


