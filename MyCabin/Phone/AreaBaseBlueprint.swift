//
//  AreaBaseBlueprint.swift
//  MyCabin
//
//  Created by Lawless on 6/22/23.
//

import SwiftUI

struct AreaBaseBlueprint<Seat: View>: View, AreaBlueprint {
        
    @AppStorage("CurrentSeat") var selectedSeat: String = ""
    @EnvironmentObject var planeViewModel: PlaneViewModel
    
    let area: PlaneArea
    let seatButton: (String, Bool) -> Seat
    
    var body: some View {
        ForEach(area.seats ?? [SeatModel]()) { seat in
            if(seat.id == selectedSeat) {
                seatButton(seat.id, true)
                    .modifier(PlaceIcon(rect: seat.rect))
            } else {
                seatButton(seat.id, false)
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
