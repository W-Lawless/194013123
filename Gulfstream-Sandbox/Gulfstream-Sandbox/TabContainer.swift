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
                
            ViewFactories.buildFlightInfo()
                .tabItem{
                    Label("My Flight", systemImage: "airplane.circle")
                        .background(Color.secondary)
                }
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
