//
//  FlightTab.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/28/22.
//

import SwiftUI

//TODO: 
struct FlightTab: View {
    var body: some View {
        TabView {
            //TODO: - Flight Tab
//            ViewFactory.buildFlightInfo()
//            ViewFactory.buildWeatherView()
        }
        .tabViewStyle(.page)
    }
}

struct FlightTab_Previews: PreviewProvider {
    static var previews: some View {
        FlightTab()
    }
}
