//
//  SeatsView.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/10/22.
//

import SwiftUI

struct SeatSelection: View {
    
    let planeViewBuilder: (PlaneSchematicDisplayMode) -> PlaneSchematic
    
    var body: some View {
        planeViewBuilder(.onlySeats)
    }
}

