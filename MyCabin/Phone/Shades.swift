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
        
        AppFactory.buildPlaneSchematic(topLevelViewModel: viewModel, options: PlaneSchematicDisplayMode.showShades)
        
        VStack{
//                Text(viewModel.activeSeat)
            if(viewModel.showPanel) {
                Text("Shade Control")
            }
        }
        
//        TabView {
//            List(viewModel.shadeList ?? [ShadeModel]()) { shade in
//                Button("OPEN \(shade.id.lowercased())") {
//                    api.commandShade(shade: shade, cmd: .OPEN)
//                }
//            }//: LIST
//
//            List(viewModel.shadeList ?? [ShadeModel]()) { shade in
//                Button("SHEER \(shade.id.lowercased())") {
//                    api.commandShade(shade: shade, cmd: .SHEER)
//                }
//            }//: LIST
//
//            List(viewModel.shadeList ?? [ShadeModel]()) { shade in
//                Button("CLOSE \(shade.id.lowercased())") {
//                    api.commandShade(shade: shade, cmd: .CLOSE)
//                }
//            }//: LIST
//        }
//        .tabViewStyle(.page)
//        .onAppear {
//            api.fetch()
//        }
    }
}

class ShadesViewModel: ViewModelWithSubViews, ObservableObject {

    @Published var showPanel: Bool = false
    @Published var shadeList: [ShadeModel]?
    
    func updateValues(_ alive: Bool, _ data: [ShadeModel]?) {
        if let data = data {
            self.shadeList = data
        }
    }
    
    func showSubView(forID: String) {
        self.showPanel = true
    }
    
}

struct Shades_Previews: PreviewProvider {
    static var previews: some View {
        AppFactory.buildShadesView()
    }
}
