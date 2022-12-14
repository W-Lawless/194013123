//
//  Lights.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/23/22.
//

import SwiftUI

struct Lights: View {
    
    @StateObject var viewModel = LightsViewModel()
    
    var body: some View {
        VStack {
            AppFactory.buildPlaneSchematic(topLevelViewModel: viewModel, options: PlaneSchematicDisplayMode.showLights)
            if(viewModel.showSubViews) {
                if let view = viewModel.bottomPanel {
                    view
                }
            }
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
}




//MARK: - View Model

class LightsViewModel: ObservableObject {
    
    @Published var loading: Bool = true
    @Published var lightList: [LightModel]?
    @Published var bottomPanel: LightsBottomPanel?
    @Published var showSubViews: Bool = false
    
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
        AppFactory.buildLightsMenu()
    }
}


