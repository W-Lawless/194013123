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
            
//            Home(navCallback: { _ in
//                print("navcallback from tabview swift ui")
//            })
//                .tabItem{
//                    Label("Home", systemImage: "house.fill")
//                }
            
            AppFactory.buildSeatSelection()
                .tabItem{
                    Label("Seats", systemImage: "s.circle")
                }
            
            AppFactory.buildWeatherView()
                .tabItem{
                    Label("Weather", systemImage: "cloud")
                }
            
            AppFactory.buildFlightInfo()
                .tabItem{
                    Label("My Flight", systemImage: "airplane.circle")
                        .background(Color.secondary)
                }
            
//            AppFactory.buildLightsView()
//                .tabItem{
//                    Label("Lights", systemImage: "lightbulb")
//                        .background(Color.secondary)
//                }
            
            AppFactory.buildShadesView()
                .tabItem{
                    Label("Shades", systemImage: "uiwindow.split.2x1")
                        .background(Color.secondary)
                }
            
///            AppFactory.buildFlightInfo()
//                .tabItem{
//                    Label("Media", systemImage: "play.tv")
//                }

//            AppFactory.buildFlightInfo()
//                .tabItem{
//                    Label("HVAC", systemImage: "thermometer.sun")
//                        .background(Color.secondary)
//                }
//            AppFactory.buildFlightInfo()
//                .tabItem{
//                    Label("Settings", systemImage: "gear")
//                        .background(Color.secondary)
//                }
//            AppFactory.buildFlightInfo()
//                .tabItem{
//                    Label("Presets", systemImage: "list.bullet.circle")
//                        .background(Color.secondary)
//                }
//            AppFactory.buildFlightInfo()
//                .tabItem{
//                    Label("Volume", systemImage: "speaker.wave.2")
//                        .background(Color.secondary)
///                }
            
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
