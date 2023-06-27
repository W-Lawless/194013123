//
//  ViewFactory+ClimateMenu.swift
//  MyCabin
//
//  Created by Lawless on 6/27/23.
//

extension ViewFactory {
    
    func buildCabinClimateView() -> CabinClimate {
        let view = CabinClimate(viewModel: state.climateViewModel, planeViewBuilder: buildPlaneSchematic)
        return view
    }
    
}
