//
//  Table.swift
//  MyCabin
//
//  Created by Lawless on 5/3/23.
//

import SwiftUI

struct MiniTable: View {
    var table: TableModel
    
    var body: some View {
        if(table.type == "CREDENZA"){
            Image("credenza_unavailable")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 96, maxHeight: 32)
        } else if (table.type == "CONFERENCE") {
            Image("table_medium_unavailable")
                .resizable()
                .scaledToFit()
                .frame(maxWidth:64)
        } else {
            Image("table_mini_unavailable")
                .resizable()
                .scaledToFit()
                .frame(width: 36, height: 36)
        }
    }
}

//struct Table_Previews: PreviewProvider {
//    static var previews: some View {
//        Table()
//    }
//}
