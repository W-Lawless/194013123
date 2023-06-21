//
//  SeatButton.swift
//  MyCabin
//
//  Created by Lawless on 5/3/23.
//

import SwiftUI

struct SeatButton: View {

    var id: String
    let options: PlaneSchematicDisplayMode
    
    @State var selected: Bool = false
    
    var body: some View {
        if(options == .onlySeats || options == .showLights ) {
            Image(selected ? "seat_selected" : "seat_selectable")
                .resizable()
                .scaledToFit()
                .frame(width:30, height: 30)
                .accessibilityIdentifier(id)
                .hapticFeedback(feedbackStyle: .light) { _ in
                    PlaneFactory.seatIconCallback(displayOptions: options, seatID: id)
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

//struct SeatButton_Previews: PreviewProvider {
//    static var previews: some View {
//       SeatButton()
//    }
//}
