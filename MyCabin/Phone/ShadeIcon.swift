//
//  ShadeIcon.swift
//  MyCabin
//
//  Created by Lawless on 5/3/23.
//

import SwiftUI

struct ShadeButton: View {
    
    var shade: ShadeModel
    
    @State var selected: Bool = false
    
    var body: some View {
            Image(selected ? "windows_selected" : "windows_selectable")
                .resizable()
                .scaledToFit()
                .frame(width:21, height: 44)
                .hapticFeedback(feedbackStyle: .light) {
                    selected.toggle()
                    PlaneFactory.shadeIconCallback(shade: shade)
                }

    }
}

//struct ShadeIcon_Previews: PreviewProvider {
//    static var previews: some View {
//        ShadeIcon()
//    }
//}
