//
//  NavigationFactory.swift
//  MyCabin
//
//  Created by Lawless on 5/5/23.
//

import Foundation
import UIKit

final class NavigationFactory {

    static let rootTabCoordinator = RootTabCoordinator()
    static let homeMenuCoordinator = HomeMenuCoordinator()

    static func buildRootTabNavigation() -> RootTabCoordinator {
        let coordinator = rootTabCoordinator
        coordinator.navigationController.tabBar.tintColor = .white

        let tabOne = self.buildHomeMenu()
        let tabTwo = ViewFactory.mediaTab
        let tabThree = ViewFactory.flightTab

        tabOne.navigationController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "ic_home_off"), selectedImage: UIImage(named: "ic_home_on"))
        tabTwo.tabBarItem = UITabBarItem(title: "Media", image: UIImage(named: "ic_media_off"), selectedImage: UIImage(named: "ic_media_on"))
        tabThree.tabBarItem = UITabBarItem(title: "Flight", image: UIImage(named: "ic_flightinfo_off"), selectedImage: UIImage(named: "ic_flightinfo_on"))

        tabOne.navigationController.accessibilityLabel = "HomeTab"
        tabTwo.accessibilityLabel = "MediaTab"
        tabThree.accessibilityLabel = "FlightTab"

        let subviews = [tabOne.navigationController, tabTwo, tabThree]

        coordinator.start(subviews: subviews)
        return coordinator
    }

    static func buildHomeMenu() -> HomeMenuCoordinator {

        let rootMenuView = ViewFactory.homeMenu
//        rootMenuView.title = "Home"
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
//        navigationBarAppearance.backgroundColor = .systemIndigo
        rootMenuView.navigationItem.standardAppearance = navigationBarAppearance
        rootMenuView.navigationItem.compactAppearance = navigationBarAppearance
        rootMenuView.navigationItem.scrollEdgeAppearance = navigationBarAppearance

//        let planeMenu = UIHostingController(rootView: AppFactory.buildPlaneSchematic())
//        planeMenu.title = "Select your seat"

        let volumeMenu = ViewFactory.volumeMenu

        let volume = UIBarButtonItem(image: UIImage(systemName: "speaker"), style: .plain, target: self, action: #selector(volumeClick))
        let icon = UIBarButtonItem(image: UIImage(named: "ic_attendant_off"), style: .plain, target: self, action: #selector(attendantClick))

        volumeMenu.accessibilityLabel = "VolumeNavBar"
        icon.accessibilityLabel = "CallAttendantNavBar"

        rootMenuView.navigationItem.rightBarButtonItems = [volume, icon]
        homeMenuCoordinator.start(subviews: [rootMenuView])

        return homeMenuCoordinator
    }

    @objc static func volumeClick() {
        homeMenuCoordinator.navigationController.present(ViewFactory.volumeMenu, animated: true)
    }

    @objc static func attendantClick() {
//        homeMenuCoordinator.navigationController.present(UIHostingController(rootView: AppFactory.buildPlaneSchematic()), animated: true)
    }
}
