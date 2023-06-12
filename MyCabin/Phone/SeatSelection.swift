//
//  SeatsView.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/10/22.
//

import SwiftUI

struct SeatSelection: View {
    
    @ObservedObject var viewModel: SeatsViewModel
    
    var body: some View {
        PlaneFactory.buildPlaneSchematic(options: .onlySeats)
//        List(viewModel.seatList ?? [SeatModel]()) { seat in
//            Button(seat.id) {
//                api.call(seat: seat)
//            }
//        } //: LIST
    }
}

//MARK: - View Model

class SeatsViewModel: ParentViewModel, ObservableObject, GCMSViewModel {
    
    @Published var showPanel: Bool = false
    @Published var seatList: [SeatModel]?
    
    func updateValues(_ data: [Codable]) {
        self.seatList = data as? [SeatModel]
    }
    
    func showSubView(forID: String) {
        
    }
    
}

//MARK: - Preview

struct Seats_Previews: PreviewProvider {
    static var previews: some View {
        ViewFactory.buildSeatSelection()
    }
}
