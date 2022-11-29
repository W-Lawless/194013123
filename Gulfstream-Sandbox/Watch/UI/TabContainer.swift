//
//  TabContainer.swift
//  wearable Watch App
//
//  Created by Lawless on 11/10/22.
//

import SwiftUI

struct TabContainer: View {
        
    var body: some View {
        TabView {
            Weather()
                .tabItem {
                    Label("Weather", systemImage: "cloud.fill")
                }
            FlightInfo()
                .tabItem {
                    Label("Flight", systemImage: "airplane")
                }
            CallAttendant(api: SeatsApi())
                .tabItem{
                    Label("Call", systemImage: "phone")
                }
        }
        .tabViewStyle(.page)
    }
}

struct TabContainer_Previews: PreviewProvider {
    static var previews: some View {
        TabContainer()
    }
}
