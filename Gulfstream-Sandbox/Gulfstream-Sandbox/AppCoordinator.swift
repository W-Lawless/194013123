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
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let tabs = TabViewCoordinator()
        tabs.start()
//        let weatherCoordinator = WeatherCoordinator()
//        weatherCoordinator.start()
//
//        self.children.append(weatherCoordinator)
        
//        window.rootViewController = weatherCoordinator.view
        window.rootViewController = tabs.tabView
    }
}

class TabsCoordinator: CoordinatorSlim {
    var view = UIViewController()
    
    func start() {
        let swiftUIview = TabContainer()
        view = UIHostingController(rootView: swiftUIview)
    }
    
}

class WeatherCoordinator: CoordinatorSlim {
    
    var view = UIViewController()
    
    func start() {
        let swiftUIview = ViewFactories.buildWeatherView()
        view = UIHostingController(rootView: swiftUIview)
    }
    
}

class TabViewCoordinator: CoordinatorSlim {
    
    var tabView = UITabBarController()
//    var tabOne = UIHostingController(rootView: Home())
    var tabOne = HomeMenuCoordinator()
    var tabTwo = UIHostingController(rootView: Media())
    var tabThree = UIHostingController(rootView: ViewFactories.buildFlightInfo())
    
    func start() {
        tabOne.start()
        tabOne.navView.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        tabTwo.tabBarItem = UITabBarItem(title: "Media", image: UIImage(systemName: "play"), selectedImage: UIImage(systemName: "play.fill"))
        tabThree.tabBarItem = UITabBarItem(title: "Flight", image: UIImage(systemName: "airplane"), selectedImage: UIImage(systemName: "airplane.circle"))
        self.tabView.viewControllers = [tabOne.navView, tabTwo, tabThree]
    }
    
}

class HomeMenuCoordinator: NSObject, CoordinatorSlim {
    
    var navView: UINavigationController
    var lightsMenu = UIHostingController(rootView: ViewFactories.buildLightsView())
    var seatsMenu = UIHostingController(rootView: ViewFactories.buildSeatSelection())
    var shadesMenu = UIHostingController(rootView: ViewFactories.buildShadesView())
    
    lazy var topLevelMenu = {
        let view = UIHostingController(rootView: Home(navCallback: self.goTo))
        

//        view.title = "First title"
        return view
    }()
    
    func goTo(_ route: MenuRouter) {
//        print("opening")
        let destination = route.view()
        navView.pushViewController(destination, animated: true)
    }
    
    override init() {
        self.navView = UINavigationController()
        navView.navigationBar.prefersLargeTitles = true
        super.init()
        
        navView.delegate = self
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
