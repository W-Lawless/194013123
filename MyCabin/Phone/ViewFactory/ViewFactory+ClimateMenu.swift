//
//  ViewFactory+ClimateMenu.swift
//  MyCabin
//
//  Created by Lawless on 6/27/23.
//
import SwiftUI

extension ViewFactory {
    
    @ViewBuilder
    func buildCabinClimateView() -> some View {
        CabinClimate(viewModel: state.climateViewModel) {
            self.buildPlaneSchematic(.tempZones)
        }
    }
    
}
