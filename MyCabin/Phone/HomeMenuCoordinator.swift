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
    }

    func start(subviews: [UIViewController]) {
        self.subviews = subviews
        navigationController.setViewControllers(subviews, animated: false)
    }
    
    func goTo<V>(destination: UIHostingController<V>) {
        destination.modalTransitionStyle = .crossDissolve
        navigationController.present(destination, animated: true)
    }
    
//    func pushView(_ route: MenuRouter, views: ViewFactory) {
//        let destination = route.view(views: views)
//        destination.modalPresentationStyle = .popover
//        navigationController.pushViewController(destination, animated: true)
//    }
    
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



