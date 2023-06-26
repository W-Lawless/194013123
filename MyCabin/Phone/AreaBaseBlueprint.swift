//
//  AreaBaseBlueprint.swift
//  MyCabin
//
//  Created by Lawless on 6/22/23.
//

import SwiftUI

struct AreaBaseBlueprint: View {
    
    @EnvironmentObject var planeViewModel: PlaneViewModel
    
    let area: PlaneArea
    @AppStorage("CurrentSeat") var selectedSeat: String = ""
    
    var body: some View {
        
        ForEach(area.seats ?? [SeatModel]()) { seat in
            if(seat.id == selectedSeat) {
                SeatButton(id: seat.id, selected: true, callback: planeViewModel.seatIconCallback)
                    .modifier(PlaceIcon(rect: seat.rect))
            } else {
                SeatButton(id: seat.id, selected: false, callback: planeViewModel.seatIconCallback)
                    .modifier(PlaceIcon(rect: seat.rect))
            }
        } //: FOR EACH
        
        ForEach(area.tables ?? [TableModel]()) { table in
            MiniTable(tableType: table.type, id: table.id)
                .modifier(PlaceIcon(rect: table.rect))
        } //: FOR EACH
        
        ForEach(area.divans ?? [DivanModel]()) { divan in
            DivanSeat(id: divan.id)
                .modifier(PlaceIcon(rect: divan.rect))
        } //: FOR EACH
        
    }
}
