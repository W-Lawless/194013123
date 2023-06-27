//
//  ViewFactory+PrimaryViews.swift
//  MyCabin
//
//  Created by Lawless on 6/27/23.
//

import SwiftUI

extension ViewFactory {
    
    func buildLoadingScreen() -> Loading {
        let view = Loading()
        return view
    }
    
    func buildMenuOverview() -> Home {
        let view = Home(homeMenuButtonBuilder: buildHomeMenuButton)
        return view
    }
    
    func buildHomeMenuButton(image: String,
                             label: String,
                             uiLabel: String,
                             destination: MenuRouter) -> HomeMenuButton {
        switch(destination) {
        case .lights:
            return HomeMenuButton(image: image, label: label, uilabel: uiLabel) {
                let destination = UIHostingController(rootView: self.buildLightsMenu())
                self.state.homeMenuCoordinator.goTo(destination: destination)
            }
        case .shades:
            return HomeMenuButton(image: image, label: label, uilabel: uiLabel) {
                let destination = UIHostingController(rootView: self.buildShadesView())
                self.state.homeMenuCoordinator.goTo(destination: destination)
            }
        case .climate:
            return HomeMenuButton(image: image, label: label, uilabel: uiLabel) {
                let destination = UIHostingController(rootView: self.buildCabinClimateView())
                self.state.homeMenuCoordinator.goTo(destination: destination)
            }
        case .seats:
            return HomeMenuButton(image: image, label: label, uilabel: uiLabel) {
                let destination = UIHostingController(rootView: self.buildSeatSelection())
                self.state.homeMenuCoordinator.goTo(destination: destination)
            }
        case .presets:
            return HomeMenuButton(image: image, label: label, uilabel: uiLabel) {
                let destination = UIHostingController(rootView: Settings())
                self.state.homeMenuCoordinator.goTo(destination: destination)
            }
        case .settings:
            return HomeMenuButton(image: image, label: label, uilabel: uiLabel) {
                let destination = UIHostingController(rootView: Settings())
                self.state.homeMenuCoordinator.goTo(destination: destination)
            }
        case .sourceList:
            return HomeMenuButton(image: image, label: label, uilabel: uiLabel) {
                let destination = UIHostingController(rootView: self.buildSourceListView())
                self.state.homeMenuCoordinator.goTo(destination: destination)
            }
        }
    }
    
    func buildMediaTab() -> MediaTab {
        let view = MediaTab(mediaViewModel: state.mediaViewModel, planeViewBuilder: buildPlaneSchematic, mediaSubViewBuilder: buildMediaSubView)
        return view
    }
    
}
