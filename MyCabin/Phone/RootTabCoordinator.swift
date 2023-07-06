//
//  RootTabCoordinator.swift
//  MyCabin
//
//  Created by Lawless on 6/21/23.
//

import UIKit
import SwiftUI

class RootTabCoordinator: NSObject  {
    
    var tabBarController = UITabBarController()
    var subviews: [UIViewController]!
    
    func goTo<V>(destination: UIHostingController<V>) {
        destination.modalTransitionStyle = .coverVertical
        tabBarController.present(destination, animated: true)
    }
    
    func goToWithParams(_ view: some View) {
        let destination = UIHostingController(rootView: view)
        destination.modalTransitionStyle = .coverVertical
        tabBarController.present(destination, animated: true)
    }
    
    func start(subviews: [UIViewController]) {
        self.subviews = subviews
        tabBarController.setViewControllers(subviews, animated: false)
    }
    
    func goToTab(_ index: Int) {
        let views = tabBarController.viewControllers
        let view = views?[index]
        guard view != nil else { return }
        tabBarController.show(view!, sender: self)
    }
    
    open func dismiss() {
        tabBarController.dismiss(animated: true) { [weak self] in
            /// because there is a leak in UIHostingControllers that prevents from deallocation
            self?.tabBarController.viewControllers = self?.subviews ?? [UIViewController()]
        }
    }
    
}
