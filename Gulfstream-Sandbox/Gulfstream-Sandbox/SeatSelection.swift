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
        
        List(viewModel.seatList ?? [Seat]()) { seat in
            Button(seat.id) {
                Task {
                    await api.call(seat: seat)
                }
            }
        } //: LIST
        .task() {
            await api.getSeats()
        }
        
    }
}

//MARK: - View Model

class SeatsViewModel: ObservableObject {

    @Published var seatList: [Seat]?
    
    @MainActor func updateValues(data: SeatsModel) {
        var out = [Seat]()
        
        data.results.forEach { Seat in
            out.append(Seat)
        }
        
        self.seatList = out
    }
    
}

//MARK: - Preview

struct Seats_Previews: PreviewProvider {
    static var previews: some View {
        ViewFactories.buildSeatsSelection()
    }
}
