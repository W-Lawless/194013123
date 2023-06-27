//
//  Shades.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/22/22.
//

import SwiftUI

struct Shades: View {
    
    @ObservedObject var viewModel: ShadesViewModel
    let planeViewBuilder: (PlaneSchematicDisplayMode) -> PlaneSchematic
    let shadeControlBuilder: () -> ShadeControl
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            planeViewBuilder(.showShades)
            
            VStack(alignment: .center) {
                if(viewModel.showPanel) {
                    shadeControlBuilder()
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            .padding(.bottom, 18)
            .background(Color.black)
            .frame(height:108, alignment: .top)
            
        }
        .environmentObject(viewModel)
        .edgesIgnoringSafeArea(.bottom)
        
    }
    
}

class ShadesViewModel: GCMSViewModel, ParentViewModel, ObservableObject {

    @Published var showPanel: Bool = false
    @Published var shadeList: [ShadeModel]?
    @Published var activeShade: ShadeModel?
    @Published var activeShades = [ShadeModel]()
    @Published var selectedShade: String = ""
    @Published var groupSelection: ShadeGroup = .none
    
    func updateValues(_ data: [Codable]) {
        self.shadeList = (data as! [ShadeModel])
    }
    
    func showSubView(forID shadeID: String) {
        //
    }
    
    func selectShade(is shadeID: String) {
        selectedShade = shadeID
    }
    
    func appendShade(_ shade: ShadeModel) {
        let match = self.activeShades.first { selected in
            return selected.id == shade.id
        }
        if(match != nil) {
            self.activeShades.removeAll { selected in
                return selected.id == shade.id
            }
        } else {
            self.activeShades.append(shade)
        }
    }
    
    func selectAll(in group: ShadeGroup) {
        switch(group) {
        case .all:
            if let shadeList {
                if(activeShades.count != shadeList.count) {
                    activeShades = shadeList
                } else {
                    activeShades = [ShadeModel]()
                }
            }
        default:
            if let shadeList {
                if(activeShades.count != shadeList.count / 2) {
                    let shades = shadeList.filter({ element in
                        return element.side == group.rawValue
                    })
                    self.activeShades = shades
                } else {
                    if (activeShades[0].side == group.rawValue) {
                        activeShades = [ShadeModel]()
                    } else {
                        let shades = shadeList.filter({ element in
                            return element.side == group.rawValue
                        })
                        self.activeShades = shades
                    }
                }
            }
        }
    }
    
}


enum ShadeGroup: String {
    case left = "LEFT"
    case right = "RIGHT"
    case none = "NONE"
    case all = "ALL"
}
