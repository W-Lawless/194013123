//
//  RootTabCoordinator.swift
//  MyCabin
//
//  Created by Lawless on 6/21/23.
//

import UIKit
import SwiftUI

class RootTabCoordinator: NSObject  {
    
    var navigationController = UITabBarController()
    var subviews: [UIViewController]!
    
    func goTo<V>(destination: UIHostingController<V>) {
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
