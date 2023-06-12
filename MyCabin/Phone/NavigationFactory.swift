//
//  NavigationFactory.swift
//  MyCabin
//
//  Created by Lawless on 5/5/23.
//

import Foundation
import UIKit
import SwiftUI

final class NavigationFactory {

    //Navigation
    static let rootTabCoordinator = RootTabCoordinator()
    static let homeMenuCoordinator = HomeMenuCoordinator()
//    static let mediaCoordinator = MediaCoordinator()
    
    static func buildRootTabNavigation() -> RootTabCoordinator {
        let coordinator = rootTabCoordinator
        coordinator.navigationController.tabBar.tintColor = .white
        
        let tabOne = buildHomeMenu()
        let tabTwo = ViewFactory.buildMediaTab()
        let tabThree = UIHostingController(rootView: FlightTab())
        
        tabOne.navigationController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        tabTwo.tabBarItem = UITabBarItem(title: "Media", image: UIImage(systemName: "play"), selectedImage: UIImage(systemName: "play.fill"))
        tabThree.tabBarItem = UITabBarItem(title: "Flight", image: UIImage(systemName: "airplane"), selectedImage: UIImage(systemName: "airplane.circle"))
        
        let subviews = [tabOne.navigationController, tabTwo, tabThree]
//        coordinator.subviews = subviews
        
        coordinator.start(subviews: subviews)
        return coordinator
    }
    
    static func buildHomeMenu() -> HomeMenuCoordinator {
        
        let rootMenuView = UIHostingController(rootView: ViewFactory.buildMenuOverview())
        rootMenuView.title = "Home"
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        //        navigationBarAppearance.backgroundColor = .systemIndigo
        rootMenuView.navigationItem.standardAppearance = navigationBarAppearance
        rootMenuView.navigationItem.compactAppearance = navigationBarAppearance
        rootMenuView.navigationItem.scrollEdgeAppearance = navigationBarAppearance

//        let planeMenu = UIHostingController(rootView: AppFactory.buildPlaneSchematic())
//        planeMenu.title = "Select your seat"
        
        let volumeMenu = UIHostingController(rootView: ViewFactory.buildVolumeView())
        volumeMenu.title = "Volume"
        
        let volume = UIBarButtonItem(image: UIImage(systemName: "speaker"), style: .plain, target: self, action: #selector(volumeClick))
        let icon = UIBarButtonItem(image: UIImage(systemName: "person"), style: .plain, target: self, action: #selector(attendantClick))
        rootMenuView.navigationItem.rightBarButtonItems = [volume, icon]
        
        homeMenuCoordinator.start(subviews: [rootMenuView])
        
        return homeMenuCoordinator
    }
    
//    static func buildMediaTab()  {
//
//        let rootMenuView = ViewFactory.buildMediaTab()
//        rootMenuView.title = "Media"
//
//        let navigationBarAppearance = UINavigationBarAppearance()
//        navigationBarAppearance.configureWithOpaqueBackground()
//        //        navigationBarAppearance.backgroundColor = .systemIndigo
//
//        rootMenuView.navigationItem.standardAppearance = navigationBarAppearance
//        rootMenuView.navigationItem.compactAppearance = navigationBarAppearance
//        rootMenuView.navigationItem.scrollEdgeAppearance = navigationBarAppearance
//
////        let planeMenu = UIHostingController(rootView: AppFactory.buildPlaneSchematic())
////        planeMenu.title = "Select your seat"
//
//        let volumeMenu = UIHostingController(rootView: ViewFactory.buildVolumeView())
//        volumeMenu.title = "Volume"
//
//        let volume = UIBarButtonItem(image: UIImage(systemName: "speaker"), style: .plain, target: self, action: #selector(volumeClick))
//        let icon = UIBarButtonItem(image: UIImage(systemName: "person"), style: .plain, target: self, action: #selector(attendantClick))
//        rootMenuView.navigationItem.rightBarButtonItems = [volume, icon]
//
//        mediaCoordinator.start(subviews: [rootMenuView])
//
//        return mediaCoordinator
//    }
    
    @objc static func volumeClick() {
        homeMenuCoordinator.navigationController.present(ViewFactory.volumeMenu, animated: true)
    }
    
    @objc static func attendantClick() {
//        homeMenuCoordinator.navigationController.present(UIHostingController(rootView: AppFactory.buildPlaneSchematic()), animated: true)
    }
}
