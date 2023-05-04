//
//  Table.swift
//  MyCabin
//
//  Created by Lawless on 5/3/23.
//

import SwiftUI

struct MiniTable: View {
    var tableType: String
    
    var body: some View {
        if(tableType == "CREDENZA"){
            Image("credenza_unavailable")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 96, maxHeight: 32)
        } else if (tableType == "CONFERENCE") {
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
