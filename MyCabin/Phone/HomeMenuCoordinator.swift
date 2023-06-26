//
//  HomeMenuCoordinator.swift
//  MyCabin
//
//  Created by Lawless on 6/21/23.
//

import UIKit
import SwiftUI

class HomeMenuCoordinator: NSObject {
    
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

extension HomeMenuCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController as? UIHostingController<Home> != nil {
            print("Home Menu")
        } else if viewController as? UIHostingController<Lights> != nil {
            print("Lights Opened")
        }
    }
}

