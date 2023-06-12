//
//  Divan.swift
//  MyCabin
//
//  Created by Lawless on 5/3/23.
//

import SwiftUI

struct DivanSeat: View {
    
    @State var selected: Bool = false

    let options: PlaneSchematicDisplayMode
    
    var body: some View {
        Group {
            if(options == .onlySeats || options == .showLights) {
                HStack(alignment: .bottom, spacing: 0) {
                    
                    DivanIcon(selected: $selected, assetName: selected ? "divan_selected_left" : "divan_selectable_left", width: 41)

                    DivanIcon(selected: $selected, assetName: selected ? "divan_selected_middle" : "divan_selectable_middle", width: 30)

                    DivanIcon(selected: $selected, assetName: selected ? "divan_selected_right" : "divan_selectable_right", width: 42)
                }
                .offset(x: 2, y: 5)
            } else {
                HStack(alignment: .bottom, spacing: 0) {
                    DivanIcon(selected: $selected, assetName: "divan_unavailable_left", width: 41)
                    
                    DivanIcon(selected: $selected, assetName: "divan_unavailable_middle", width: 30)
                    
                    DivanIcon(selected: $selected, assetName: "divan_unavailable_right", width: 42)
                }
                .offset(x: 2, y: 5)
            }
        }

    }
}

struct DivanIcon: View  {
    
    @Binding var selected: Bool
    let assetName: String
    let width: CGFloat
    
    var body: some View {
        Image(assetName)
            .resizable()
            .scaledToFit()
            .frame(width: width)
            .hapticFeedback(feedbackStyle: .light) { _ in
                selected.toggle()
            }
    }
}

//struct Divan_Previews: PreviewProvider {
//    static var previews: some View {
//        Divan()
//    }
//}
