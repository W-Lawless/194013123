//
//  AppCoordinator.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/27/22.
//

import SwiftUI
import UIKit

class AppCoordinator: CoordinatorSlim {
    
    let window: UIWindow
    var children = [CoordinatorSlim]()
    let cabin = CabinAPI()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        
//        cabin.monitor.startMonitor(interval: 3.0, callback: cabin.monitorCallback)
        
        
        let tabs = TabViewCoordinator()
        tabs.start()
        
        window.rootViewController = tabs.tabView
        //        self.children.append(weatherCoordinator)
    }
}



class TabViewCoordinator: CoordinatorSlim {
    
    var tabView = UITabBarController()

    var tabOne = HomeMenuCoordinator()
    var tabTwo = UIHostingController(rootView: MediaTab())
    var tabThree = UIHostingController(rootView: FlightTab())
    
    func start() {
        tabOne.start()
        tabOne.navView.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        tabTwo.tabBarItem = UITabBarItem(title: "Media", image: UIImage(systemName: "play"), selectedImage: UIImage(systemName: "play.fill"))
        tabThree.tabBarItem = UITabBarItem(title: "Flight", image: UIImage(systemName: "airplane"), selectedImage: UIImage(systemName: "airplane.circle"))
        self.tabView.viewControllers = [tabOne.navView, tabTwo, tabThree]
        self.tabView.tabBar.tintColor = .white
    }
    
}

class HomeMenuCoordinator: NSObject, CoordinatorSlim {
    
    var navView: UINavigationController
    var lightsMenu = UIHostingController(rootView: ViewFactories.buildLightsView())
    var seatsMenu = UIHostingController(rootView: ViewFactories.buildSeatSelection())
    var shadesMenu = UIHostingController(rootView: ViewFactories.buildShadesView())
    
    var topLevelMenu: UIHostingController<Home>!
    
    func goTo(_ route: MenuRouter) {
        let destination = route.view()
        navView.pushViewController(destination, animated: true)
    }
    
    override init() {
        self.navView = UINavigationController()
//        navView.navigationBar.prefersLargeTitles = true
        navView.navigationBar.tintColor = .white
        super.init()
        
        let topView = UIHostingController(rootView: Home(navCallback: goTo))
        topView.title = "Home"
        let volume = UIBarButtonItem(image: UIImage(systemName: "speaker"), style: .plain, target: self, action: #selector(toolBarClick))
        let icon = UIBarButtonItem(image: UIImage(systemName: "person"), style: .plain, target: self, action: #selector(toolBarClick))
        
        
//        topView.toolbarItems = [volume]
//        topView.setToolbarItems(topView.toolbarItems, animated: true)
        
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
//        navigationBarAppearance.backgroundColor = .systemIndigo
//        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.shadow: al]
        
        topView.navigationItem.standardAppearance = navigationBarAppearance
        topView.navigationItem.compactAppearance = navigationBarAppearance
        topView.navigationItem.scrollEdgeAppearance = navigationBarAppearance
        
        
        topView.navigationItem.rightBarButtonItems = [volume, icon]
        
        self.topLevelMenu = topView
        
        navView.delegate = self
    }
    
    @objc func toolBarClick() {
        print("volume!")
    }

    func start() {
        navView.setViewControllers([topLevelMenu], animated: false)
    }
}

extension HomeMenuCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController,
                              animated: Bool) {
        
//        if viewController as? UIHostingController<FirstDetailView> != nil {
//            print("detail will be shown")
//        } else if viewController as? FirstViewController != nil {
//            print("first will be shown")
//        }
        
    }
}


class WeatherCoordinator: CoordinatorSlim {
    
    var view = UIViewController()
    
    func start() {
        let swiftUIview = ViewFactories.buildWeatherView()
        view = UIHostingController(rootView: swiftUIview)
    }
    
}
