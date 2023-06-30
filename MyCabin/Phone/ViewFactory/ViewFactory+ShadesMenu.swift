//
//  ViewFactory+ShadesMenu.swift
//  MyCabin
//
//  Created by Lawless on 6/27/23.
//

extension ViewFactory {
    
    func buildShadesView() -> Shades {
        let view = Shades(viewModel: state.shadesViewModel, planeViewBuilder: buildPlaneSchematic, shadeControlBuilder: buildShadeControl)
        return view
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
