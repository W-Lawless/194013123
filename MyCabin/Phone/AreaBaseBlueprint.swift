//
//  AreaBaseBlueprint.swift
//  MyCabin
//
//  Created by Lawless on 6/22/23.
//

import SwiftUI

struct AreaBaseBlueprint: View, AreaBlueprint {
    
    @AppStorage("CurrentSeat") var selectedSeat: String = ""
    @EnvironmentObject var planeViewModel: PlaneViewModel
    
    let area: PlaneArea
    let seatButtonBuilder: (String, Bool) -> SeatButton
    
    var body: some View {
        ForEach(area.seats ?? [SeatModel]()) { seat in
            if(seat.id == selectedSeat) {
                seatButtonBuilder(seat.id, true)//SeatButton(id: seat.id, selected: true, callback: planeViewModel.seatIconCallback)
                    .modifier(PlaceIcon(rect: seat.rect))
            } else {
                seatButtonBuilder(seat.id, false)
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
