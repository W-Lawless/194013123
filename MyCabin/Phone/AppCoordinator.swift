//
//  AppCoordinator.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/27/22.
//

import SwiftUI
import UIKit
import Combine

class AppCoordinator: CoordinatorSlim {
    
    let window: UIWindow
    var children = [CoordinatorSlim]()
    
    let connectionPublisher = CurrentValueSubject<Bool, Never>(false)
    var subscriptions = Set<AnyCancellable>()

    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        
        let cabin = CabinAPI(publisher: connectionPublisher)

        let tabs = TabViewCoordinator(api: cabin)
        tabs.start()
        
        let loading = UIHostingController(rootView: Loading(api: cabin))
        
        let rootNavView = UINavigationController()
        rootNavView.navigationBar.isHidden = true
        rootNavView.setViewControllers([tabs.tabView,loading], animated: true)
        self.window.rootViewController = rootNavView
        
        connectionPublisher
            .sink{ value in
                if(value){
                    DispatchQueue.main.async {
                        let last = (rootNavView.viewControllers.count - 1)
                        if(rootNavView.viewControllers[last] === loading) {
                            cabin.monitor.stopMonitor()
                            rootNavView.popViewController(animated: true)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        let last = (rootNavView.viewControllers.count - 1)
                        if(rootNavView.viewControllers[last] !== loading) {
                            rootNavView.pushViewController(loading, animated: true)
                        }
                    }
                }
            }
            .store(in: &subscriptions)
    }
}



class TabViewCoordinator: CoordinatorSlim {
    
    var api: CabinAPI
    var tabView: HomeTabs

    init(api: CabinAPI) {
        self.api = api
        self.tabView = HomeTabs(api: api)
    }
    
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
    let volumeMenu = UIHostingController(rootView: ViewFactories.buildVolumeView())
    
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
        let volume = UIBarButtonItem(image: UIImage(systemName: "speaker"), style: .plain, target: self, action: #selector(volumeClick))
        let icon = UIBarButtonItem(image: UIImage(systemName: "person"), style: .plain, target: self, action: #selector(attendantClick))
        
        
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
    
    @objc func volumeClick() {
        print("volume!")
        navView.pushViewController(self.volumeMenu, animated: true)
    }
    
    @objc func attendantClick() {
        print("plane waitress")
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




class HomeTabs: UITabBarController {
    
    var api: CabinAPI

    init(api: CabinAPI) {
        self.api = api
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        api.monitor.startMonitor(interval: 30, callback: api.monitorCallback)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        api.monitor.stopMonitor()
    }
}



//class WeatherCoordinator: CoordinatorSlim {
//
//    var view = UIViewController()
//
//    func start() {
//        let swiftUIview = ViewFactories.buildWeatherView()
//        view = UIHostingController(rootView: swiftUIview)
//    }
//
//}
