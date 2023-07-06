//
//  ViewFactory+ShadesMenu.swift
//  MyCabin
//
//  Created by Lawless on 6/27/23.
//

import SwiftUI

extension ViewFactory {
    
    @ViewBuilder
    func buildShadesView() -> some View {
        Shades(viewModel: state.shadesViewModel, shadeControlBuilder: buildShadeControl) {
            self.buildPlaneSchematic(.showShades)
        }
    }
    
    func buildShadeControl() -> ShadeControl {
        let view = ShadeControl(buttonCallback: commandActiveShades)
        return view
    }
    
    func commandActiveShades(shadeState: ShadeStates) {
        self.state.shadesViewModel.activeShades.forEach { shade in
            api.apiClient.commandShade(shade: shade, cmd: shadeState)
        }
    }
}
