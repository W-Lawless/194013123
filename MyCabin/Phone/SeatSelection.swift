//
//  SeatsView.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/10/22.
//

import SwiftUI

struct SeatSelection: View {
    
    @ObservedObject var viewModel: SeatsViewModel
    let planeViewBuilder: (PlaneSchematicDisplayMode) -> PlaneSchematic

    
    var body: some View {
        planeViewBuilder(.onlySeats)
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
