//
//  TabView.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/9/22.
//

import SwiftUI

struct TabContainer: View {
        
    var body: some View {
        TabView {
            Home()
                .tabItem{
                    Label("Home", systemImage: "house.fill")
                }
            ViewFactories.buildSeatSelection()
                .tabItem{
                    Label("Media", systemImage: "play.tv")
                }
            
            ViewFactories.buildWeatherView()
                .tabItem{
                    Label("Weather", systemImage: "cloud")
                }
            
            ViewFactories.buildFlightInfo()
                .tabItem{
                    Label("My Flight", systemImage: "airplane.circle")
                        .background(Color.secondary)
                }
            ViewFactories.buildFlightInfo()
                .tabItem{
                    Label("Shades", systemImage: "uiwindow.split.2x1")
                        .background(Color.secondary)
                }
//            ViewFactories.buildFlightInfo()
//                .tabItem{
//                    Label("Lights", systemImage: "lightbulb")
//                        .background(Color.secondary)
//                }
//            ViewFactories.buildFlightInfo()
//                .tabItem{
//                    Label("HVAC", systemImage: "thermometer.sun")
//                        .background(Color.secondary)
//                }
//            ViewFactories.buildFlightInfo()
//                .tabItem{
//                    Label("Settings", systemImage: "gear")
//                        .background(Color.secondary)
//                }
//            ViewFactories.buildFlightInfo()
//                .tabItem{
//                    Label("Presets", systemImage: "list.bullet.circle")
//                        .background(Color.secondary)
//                }
//            ViewFactories.buildFlightInfo()
//                .tabItem{
//                    Label("Volume", systemImage: "speaker.wave.2")
//                        .background(Color.secondary)
//                }
            
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}


//MARK: - Preview

struct NavView_Previews: PreviewProvider {
    static var previews: some View {
        TabContainer()
    }
}
