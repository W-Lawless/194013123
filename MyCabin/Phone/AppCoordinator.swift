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
            .sink{ pulse in
                DispatchQueue.main.async {
                    let last = (rootNavView.viewControllers.count - 1)
                    if(pulse){
                        if(rootNavView.viewControllers[last] === loading) { ///Check view order
                            AppFactory.fetchAll()
                            cabin.monitor.stopMonitor()
                            rootNavView.popViewController(animated: true)
                        }
                    } else { //: Pulse false
                        if(rootNavView.viewControllers[last] !== loading) { /// Check already loading
                            rootNavView.pushViewController(loading, animated: true)
                        }
                    }
                }
            }
            .store(in: &subscriptions)
    }
}


//MARK: - TabView


class TabViewCoordinator: CoordinatorSlim {
    
    var api: CabinAPI
    var tabView: HomeTabs

    init(api: CabinAPI) {
        self.api = api
        self.tabView = HomeTabs(api: api)
    }
    
    var tabOne = AppFactory.buildHomeMenu()
    var tabTwo = UIHostingController(rootView: MediaTab())
    var tabThree = UIHostingController(rootView: FlightTab())
    
    func start() {
        tabOne.navigationController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        tabTwo.tabBarItem = UITabBarItem(title: "Media", image: UIImage(systemName: "play"), selectedImage: UIImage(systemName: "play.fill"))
        tabThree.tabBarItem = UITabBarItem(title: "Flight", image: UIImage(systemName: "airplane"), selectedImage: UIImage(systemName: "airplane.circle"))
        
        self.tabView.viewControllers = [tabOne.navigationController, tabTwo, tabThree]
        self.tabView.tabBar.tintColor = .white
    }
    
}


//MARK: - Home Tab

class HomeMenuCoordinator: NSObject {
    
    var navigationController: UINavigationController
    
    override init() {
        self.navigationController = UINavigationController()
        navigationController.navigationBar.tintColor = .white
        super.init()
        
        navigationController.delegate = self
    }

    func start<T>(subviews: [UIHostingController<T>]) {
        navigationController.setViewControllers(subviews, animated: false)
    }
    
    func goTo(_ route: MenuRouter) {
        let destination = route.view(navCallback: popView)
        navigationController.pushViewController(destination, animated: true)
    }
    
    func popView() {
        navigationController.popViewController(animated: true)
    }
    
    public func popToRoot() {
        navigationController.popToRootViewController(animated: true)
    }
    
    open func dismiss(animated: Bool = true) {
        navigationController.dismiss(animated: true) { [weak self] in
            /// because there is a leak in UIHostingControllers that prevents from deallocation
            self?.navigationController.viewControllers = []
        }
    }
    
}

extension HomeMenuCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController as? UIHostingController<Home> != nil {
            print("Home Menu")
        } else if viewController as? UIHostingController<Lights> != nil {
            print("Lights Opened")
        }
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
    
//    override func viewDidDisappear(_ animated: Bool) {
//        api.monitor.stopMonitor()
//    }
}
