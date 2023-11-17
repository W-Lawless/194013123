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

    let views: ViewFactory
    let rootTabCoordinator: RootTabCoordinator
    let homeMenuCoordinator: HomeMenuCoordinator
    let volumeView: UIHostingController<Volume>

    init(views: ViewFactory, rootTabCoordinator: RootTabCoordinator, homeMenuCoordinator: HomeMenuCoordinator) {
        self.views = views
        self.rootTabCoordinator = rootTabCoordinator
        self.homeMenuCoordinator = homeMenuCoordinator
        self.volumeView = views.buildUIHostedVolumeMenu()
    }
    
    func configureRootTabCoordinator() {
        let coordinator = rootTabCoordinator
        coordinator.tabBarController.tabBar.tintColor = .white
        
        coordinator.tabBarController.tabBar.backgroundColor = UIColor(named: "PrimaryColor")

        let tabOne = self.buildHomeMenu()
        let tabTwo = views.buildUIHostedMediaTab()
        let tabThree = views.buildUIHostedFlightTab()

        tabOne.navigationController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "ic_home_off"), selectedImage: UIImage(named: "ic_home_on"))
        tabTwo.tabBarItem = UITabBarItem(title: "Media", image: UIImage(named: "ic_media_off"), selectedImage: UIImage(named: "ic_media_on"))
        tabThree.tabBarItem = UITabBarItem(title: "Flight", image: UIImage(named: "ic_flightinfo_off"), selectedImage: UIImage(named: "ic_flightinfo_on"))

        tabOne.navigationController.accessibilityLabel = "HomeTab"
        tabTwo.accessibilityLabel = "MediaTab"
        tabThree.accessibilityLabel = "FlightTab"

        let subviews = [tabOne.navigationController, tabTwo, tabThree]

        coordinator.start(subviews: subviews)

    }

    func buildHomeMenu() -> HomeMenuCoordinator {

        let rootMenuView = views.buildUIHostedHomeMenu()
//        rootMenuView.title = "Home"
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = UIColor(named: "PrimaryColor")
        rootMenuView.navigationItem.standardAppearance = navigationBarAppearance
        rootMenuView.navigationItem.compactAppearance = navigationBarAppearance
        rootMenuView.navigationItem.scrollEdgeAppearance = navigationBarAppearance

        let volumeMenu = self.volumeView

        let volume = UIBarButtonItem(image: UIImage(systemName: "speaker"), style: .plain, target: self, action: #selector(volumeClick))
        let icon = UIBarButtonItem(image: UIImage(named: "ic_attendant_off"), style: .plain, target: self, action: #selector(attendantClick))

        volumeMenu.accessibilityLabel = "VolumeNavBar"
        icon.accessibilityLabel = "CallAttendantNavBar"

        rootMenuView.navigationItem.rightBarButtonItems = [volume, icon]
        
        homeMenuCoordinator.start(subviews: [rootMenuView])
        
        return homeMenuCoordinator
    }

    @objc func volumeClick() {
        homeMenuCoordinator.navigationController.present(self.volumeView, animated: true)
    }

    @objc func attendantClick() {
//        homeMenuCoordinator.navigationController.present(UIHostingController(rootView: AppFactory.buildPlaneSchematic()), animated: true)
    }
}
