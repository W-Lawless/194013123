//
//  Home.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/9/22.
//

import SwiftUI
import Combine

struct Home: View {
    
    var shades = ShadesAPI()
    
    var body: some View {
        VStack { //: VSTQ 1
            Image(systemName: "house.fill")
                .resizable()
                .scaledToFit()
                .frame(height: 72)
                .hapticFeedback()

            Button("Shades Load") {
                shades.fetchEndpoint()
            }

        } //VSTQ: 1
        .frame(height: 300)
        .padding(.horizontal, 24)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
