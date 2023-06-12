//
//  Shades.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/22/22.
//

import SwiftUI

struct Shades: View {
    
    @ObservedObject var viewModel: ShadesViewModel
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            PlaneFactory.buildPlaneSchematic(options: .showShades)
            
            VStack(alignment: .center) {
                if(viewModel.showPanel) {
                    ShadeControl()
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

class ShadesViewModel: GCMSViewModel, ParentViewModel, ObservableObject {

    @Published var showPanel: Bool = false
    @Published var shadeList: [ShadeModel]?
    @Published var activeShade: ShadeModel?
    @Published var selectedShade: String = ""
    
    func updateValues(_ data: [Codable]) {
        self.shadeList = (data as! [ShadeModel])
    }
    
    func showSubView(forID shadeID: String) {
        //
    }
    
    func selectShade(is shadeID: String) {
        selectedShade = shadeID
    }
    
}

struct Shades_Previews: PreviewProvider {
    static var previews: some View {
        ViewFactory.buildShadesView()
    }
}
