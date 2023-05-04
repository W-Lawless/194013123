//
//  SeatButton.swift
//  MyCabin
//
//  Created by Lawless on 5/3/23.
//

import SwiftUI

struct SeatButton<AViewModel: ViewModelWithSubViews & ObservableObject>: View {

    @ObservedObject var topLevelViewModel: AViewModel
    var seat: SeatModel
    var navigation: HomeMenuCoordinator
    let options: PlaneSchematicDisplayMode
    
    @State var selected: Bool = false
    
    var body: some View {
        if(options == .onlySeats || options == .showLights ) {
            Image(selected ? "seat_selected" : "seat_selectable")
                .resizable()
                .scaledToFit()
                .frame(width:30, height: 30)
                .hapticFeedback(feedbackStyle: .light) {
                    options.seatIconCallback(topLevelViewModel: topLevelViewModel, seatID: seat.id, nav: navigation)
                }
        } else {
            Image("seat_unavailable")
                .resizable()
                .scaledToFit()
                .frame(width:30, height: 30)
        }
    }
}

//struct SeatButton_Previews: PreviewProvider {
//    static var previews: some View {
//       SeatButton()
//    }
//}
