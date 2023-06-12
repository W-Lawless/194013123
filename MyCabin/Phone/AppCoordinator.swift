//
//  AppCoordinator.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/27/22.
//

import UIKit
import SwiftUI

class AppCoordinator {
    
    let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        
        let cabin = PlaneFactory.cabinAPI
        let tabs = NavigationFactory.buildRootTabNavigation()
        
        let loading = ViewFactory.loadingView
        
        let rootNavView = UINavigationController()
        rootNavView.navigationBar.isHidden = true
        rootNavView.setViewControllers([tabs.navigationController,loading], animated: true)
        self.window.rootViewController = rootNavView
        
        PlaneFactory.cabinConnectionPublisher
            .sink(receiveCompletion: { completion in
                switch (completion) {
                case .finished:
                    print("cabin api ping closed")
                case .failure:
                    print("error pinging cabin")
                }
            }, receiveValue: { pulse in
                DispatchQueue.main.async {
                    let last = (rootNavView.viewControllers.count - 1)
                    if(pulse){
                        if(rootNavView.viewControllers[last] === loading) { ///Check view order
                            PlaneFactory.connectToPlane()
                            cabin.monitor.stopMonitor()
                            rootNavView.popViewController(animated: true)
                        }
                    } else { //: Pulse false
                        if(rootNavView.viewControllers[last] !== loading) { /// Check already loading
                            rootNavView.pushViewController(loading, animated: true)
                        }
                    }
                }
            })
            .store(in: &PlaneFactory.cancelTokens)
    }
}

//MARK: - TabView

class RootTabCoordinator: NSObject  {
    
    var navigationController = HomeTabs()
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

//MARK: - Media


//        switch(route.transition){
//        case .presentFullscreen(let presentation):
//            ()
//        case .presentModally(let presentation):
//            destination.modalPresentationStyle = presentation
//        case .push(let presentation):
//            destination.modalPresentationStyle = presentation
//        }

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
        if viewController as? UIHostingController<MediaTab> != nil {
            print("media tab")
//            dump(StateFactory.mediaViewModel)
        }
    }

    
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
    }
}



class HomeTabs: UITabBarController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        PlaneFactory.cabinAPI.monitor.startMonitor(interval: 30, callback: PlaneFactory.cabinAPI.monitorCallback)
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        api.monitor.stopMonitor()
//    }
}
