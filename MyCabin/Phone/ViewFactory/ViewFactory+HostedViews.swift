//
//  ViewFactory+HostedViews.swift
//  MyCabin
//
//  Created by Lawless on 6/27/23.
//

import SwiftUI

extension ViewFactory {
    
    func buildUIHostedLoadingScreen() -> UIHostingController<Loading> {
        let view = UIHostingController(rootView: buildLoadingScreen())
        return view
    }
    
    func buildUIHostedHomeMenu() -> UIHostingController<Home> {
        let view = UIHostingController(rootView: buildMenuOverview())
        return view
    }
    
    func buildUIHostedVolumeMenu() -> UIHostingController<Volume> {
        let view = UIHostingController(rootView: buildVolumeView())
        return view
    }
    
    func buildUIHostedMediaTab() ->  UIHostingController<MediaTab> {
        let view = UIHostingController(rootView: buildMediaTab())
        return view
    }
    
    func buildUIHostedFlightTab() -> UIHostingController<FlightInfo> {
        let view = UIHostingController(rootView: buildFlightInfo())
        return view
    }
}
