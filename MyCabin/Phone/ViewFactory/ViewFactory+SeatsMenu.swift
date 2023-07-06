//
//  ViewFactory+SeatsMenu.swift
//  MyCabin
//
//  Created by Lawless on 6/27/23.
//

import SwiftUI

extension ViewFactory {
    
    @ViewBuilder
    func buildSeatSelection() -> some View {
        SeatSelection() {
            self.buildPlaneSchematic(.onlySeats)
        }
    }
    
}
