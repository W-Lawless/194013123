//
//  Shades.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/22/22.
//

import SwiftUI

struct Shades: View {
    
    @ObservedObject var viewModel: ShadesViewModel
    var api: ShadesAPI
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            AppFactory.buildPlaneSchematic(topLevelViewModel: viewModel, options: PlaneSchematicDisplayMode.showShades)
            
            VStack(alignment: .center) {
                if(viewModel.showPanel) {
                    ShadeControl(api: api)
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            .padding(.bottom, 18)
            .background(Color.black)
            .frame(height:108, alignment: .top)
            
        }
        .edgesIgnoringSafeArea(.bottom)
        
    }
    
}

class ShadesViewModel: ViewModelWithSubViews, ObservableObject {
    typealias ResponseModel = ShadeModel
    

    @Published var activeShadeID: String = ""
    @Published var showPanel: Bool = false
    @Published var shadeList: [ShadeModel]?
    @Published var activeShade: ShadeModel?
    
    func updateValues(_ alive: Bool, data: [ShadeModel]) {
//        if let data = data {
            self.shadeList = data
//        }
    }
    
    func showSubView(forID shade: String) {
        if(activeShadeID != shade){
            showPanel = true
            activeShadeID = shade
        } else {
            showPanel.toggle()
        }
    }
    
}

struct Shades_Previews: PreviewProvider {
    static var previews: some View {
        AppFactory.buildShadesView()
    }
}
