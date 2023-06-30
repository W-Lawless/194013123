//
//  ShadesViewModel.swift
//  MyCabin
//
//  Created by Lawless on 6/28/23.
//

import SwiftUI

class ShadesViewModel: ObservableObject {

    @Published var showPanel: Bool = false
    @Published var shadeList = [ShadeModel]()
    @Published var activeShades = [ShadeModel]()
    @Published var groupSelection: ShadeGroup = .none
    
    func updateShades(_ data: [ShadeModel]) {
        self.shadeList = data
    }

    
    func selectShade(_ selectedShade: ShadeModel) {
        let alreadySelected = activeShades.contains { activeShade in
            selectedShade.id == activeShade.id
        }
        if (alreadySelected) {
            activeShades.removeAll { activeShade in
                selectedShade == activeShade
            }
        } else {
            activeShades.append(selectedShade)
        }
        toggleSubView()
    }
    
    func selectAll(in group: ShadeGroup) {
        switch(group) {
        case .all:
            if(activeShades.count != shadeList.count) {
                activeShades = shadeList
            } else {
                activeShades = [ShadeModel]()
            }
        default:
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
    
    func clearSelection() {
        self.activeShades = [ShadeModel]()
        self.groupSelection = .none
    }
    
    private func toggleSubView() {
        if (activeShades.count > 0) {
            showPanel = true
        } else {
            showPanel = false
        }
    }
}

enum ShadeGroup: String {
    case left = "LEFT"
    case right = "RIGHT"
    case none = "NONE"
    case all = "ALL"
}

enum ShadeStates: String {
    case OPEN
    case CLOSE
    case SHEER
    case NONE
}
