//
//  ViewFactory+SeatsMenu.swift
//  MyCabin
//
//  Created by Lawless on 6/27/23.
//

extension ViewFactory {
    
    func buildSeatSelection() -> SeatSelection {
        let view = SeatSelection(viewModel: state.seatsViewModel, planeViewBuilder: buildPlaneSchematic)
        return view
    }
    
}
