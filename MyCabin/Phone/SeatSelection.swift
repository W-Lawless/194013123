//
//  SeatsView.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/10/22.
//

import SwiftUI

struct SeatSelection: View {
    
    @ObservedObject var viewModel: SeatsViewModel
    var api: SeatsAPI
    
    var body: some View {
        List(viewModel.seatList ?? [SeatModel]()) { seat in
            Button(seat.id) {
                api.call(seat: seat)
            }
        } //: LIST
    }
}

//MARK: - View Model

class SeatsViewModel: ObservableObject {

    @Published var seatList: [SeatModel]?
    
    func updateValues(_ alive: Bool, _ data: [SeatModel]) {
        self.seatList = data
    }
    
}

//MARK: - Preview

struct Seats_Previews: PreviewProvider {
    static var previews: some View {
        AppFactory.buildSeatSelection()
    }
}
