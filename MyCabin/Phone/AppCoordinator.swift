//
//  AppCoordinator.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/27/22.
//

import UIKit
import SwiftUI
import Combine

class AppCoordinator {
    
    typealias CabinAPIAdaptor = CabinAPI<EndpointFormats.Head, EmptyResponse>
    typealias CabinLoadingView = UIHostingController<Loading>
    typealias CabinPublisher = CurrentValueSubject<Bool, Never>
    typealias SinkCompletion = (Subscribers.Completion<Never>) -> Void
    typealias SinkValue =  (Bool) -> Void
    
    let window: UIWindow
    let cabin: CabinAPIAdaptor
    var loadingView: CabinLoadingView
    var tabs: RootTabCoordinator
    let rootNavView = UINavigationController()
    
    init(window: UIWindow,
         cabin: CabinAPIAdaptor = PlaneFactory.cabinAPI,
         loadingView: CabinLoadingView = ViewFactory.loadingView,
         tabs: RootTabCoordinator = NavigationFactory.buildRootTabNavigation()) {
        self.window = window
        self.cabin = cabin
        self.loadingView = loadingView
        self.tabs = tabs
    }
    
    func start(
        publisher: CabinPublisher = PlaneFactory.cabinConnectionPublisher,
        sinkCompletion endSink: @escaping SinkCompletion,
        sinkValue onSink: @escaping SinkValue) {
        
        rootNavView.navigationBar.isHidden = true
        rootNavView.setViewControllers([tabs.navigationController,loadingView], animated: true)
        self.window.rootViewController = rootNavView
        
        publisher.sink(receiveCompletion: endSink, receiveValue: onSink).store(in: &PlaneFactory.cancelTokens)
    }
    
    func goTo(_ route: AppRouter) {
        switch route {
        case .cabinFound:
            startMonitor(atInterval: 30.0)
            if(rootNavView.visibleViewController === loadingView) { ///Check view order
                rootNavView.popViewController(animated: true)
            }
        case .loadCabin:
            startMonitor(atInterval: 3.0)
            if(rootNavView.visibleViewController !== loadingView) { /// Check already loading
                rootNavView.pushViewController(loadingView, animated: true)
            }
        }
    }
    
    func startMonitor(atInterval interval: Double){
        PlaneFactory.cabinAPI.monitor.stopMonitor()
        PlaneFactory.cabinAPI.monitor.startMonitor(interval: interval, callback: PlaneFactory.cabinAPI.monitorCallback)
    }
 
    enum AppRouter {
        case cabinFound
        case loadCabin
    }
}


//MARK: - TabView

class RootTabCoordinator: NSObject  {
    
    var navigationController = UITabBarController()
    var subviews: [UIViewController]!
    
    func goTo(_ route: MenuRouter) {
        let destination = route.view()
        destination.modalTransitionStyle = .coverVertical
        navigationController.present(destination, animated: true)
    }
    
    func goToWithParams(_ view: some View) {
        let destination = UIHostingController(rootView: view)
        destination.modalTransitionStyle = .coverVertical
        navigationController.present(destination, animated: true)
    }
    
    func start(subviews: [UIViewController]) {
        self.subviews = subviews
        navigationController.delegate = self
        navigationController.setViewControllers(subviews, animated: true)
    }
    
    func goToTab(_ index: Int) {
        let views = navigationController.viewControllers
        let view = views?[index]
        guard view != nil else { return }
        navigationController.show(view!, sender: self)
    }
    
    open func dismiss() {
        navigationController.dismiss(animated: true) { [weak self] in
            /// because there is a leak in UIHostingControllers that prevents from deallocation
            self?.navigationController.viewControllers = self?.subviews ?? [UIViewController()]
        }
    }
    
}

//MARK: - Home Tab

class HomeMenuCoordinator: NSObject, Coordinator {
    
    var navigationController: UINavigationController
    var subviews: [UIViewController]!
    
    override init() {
        self.navigationController = UINavigationController()
        navigationController.navigationBar.tintColor = .white
        super.init()
        
        navigationController.delegate = self
    }

    func start(subviews: [UIViewController]) {
        self.subviews = subviews
        navigationController.setViewControllers(subviews, animated: false)
    }
    
    func goTo(_ route: MenuRouter) {
        let destination = route.view()
        destination.modalTransitionStyle = .crossDissolve
        navigationController.present(destination, animated: true)
    }
    
    func pushView(_ route: MenuRouter) {
        let destination = route.view()
        destination.modalPresentationStyle = .popover
        navigationController.pushViewController(destination, animated: true)
    }
    
    func popView() {
        navigationController.popViewController(animated: true)
    }
    
    func popToRoot() {
        navigationController.popToRootViewController(animated: true)
    }
    
    open func dismiss() {
        navigationController.dismiss(animated: true) { [weak self] in
            /// because there is a leak in UIHostingControllers that prevents from deallocation
            self?.navigationController.viewControllers = self?.subviews ?? [UIViewController()]
        }
    }
}

//MARK: - UIVC Type Casting / OnLoad

extension HomeMenuCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController as? UIHostingController<Home> != nil {
            print("Home Menu")
        } else if viewController as? UIHostingController<Lights> != nil {
            print("Lights Opened")
        }
    }
}

extension RootTabCoordinator: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController as? UINavigationController != nil {
            print("Home Tab")
        }
        if viewController as? UIHostingController<MediaTab> != nil {
            print("media tab")
        }
    }
    
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
    }
}




