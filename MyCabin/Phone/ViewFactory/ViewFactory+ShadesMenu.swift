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
    
    //    func buildShadeMenuPlaneDisplayOptions() -> ShadeMenuPlaneDisplayOptions {
    //        let view = ShadeMenuPlaneDisplayOptions()
    //        return view
    //    }
    //
    //    func buildShadeGroupButton() -> ShadeGroupButton {
    //        let view = ShadeGroupButton(group: T##ShadeGroup, text: T##String)
    //    }
    
    func buildShadeControl() -> ShadeControl {
        let view = ShadeControl(apiClient: api.apiClient)
        return view
    }
    
}
