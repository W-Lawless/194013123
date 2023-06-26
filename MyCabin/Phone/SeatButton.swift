//
//  SeatButton.swift
//  MyCabin
//
//  Created by Lawless on 5/3/23.
//

import SwiftUI

struct SeatButton: View {

    @EnvironmentObject var planeViewModel: PlaneViewModel
    
    var id: String    
    @State var selected: Bool = false
    let callback: (PlaneSchematicDisplayMode, String) -> Void
    
    var body: some View {
        if(planeViewModel.planeDisplayOptions == .onlySeats || planeViewModel.planeDisplayOptions == .showLights ) {
            Image(selected ? "seat_selected" : "seat_selectable")
                .resizable()
                .scaledToFit()
                .frame(width:30, height: 30)
                .accessibilityIdentifier(id)
                .hapticFeedback(feedbackStyle: .light) { _ in
                    callback(planeViewModel.planeDisplayOptions, id)
                }
        } else {
            Image("seat_unavailable")
                .resizable()
                .scaledToFit()
                .frame(width:30, height: 30)
                .accessibilityIdentifier(id)
        }
    }
}
