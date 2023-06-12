//
//  MediaCoordinator.swift
//  MyCabin
//
//  Created by Lawless on 5/6/23.
//

import Foundation
import UIKit
import SwiftUI

//
//class MediaCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
//
//    var navigationController: UINavigationController
//    var subviews: [UIViewController]!
//
//    override init() {
//        self.navigationController = UINavigationController()
//        navigationController.navigationBar.tintColor = .white
//        super.init()
//
//        navigationController.delegate = self
//    }
//
//    func start(subviews: [UIViewController]) {
//        self.subviews = subviews
//        navigationController.setViewControllers(subviews, animated: false)
//    }
//
//    func goTo(_ route: MediaRouter) {
//        let destination = route.view()
////        destination.modalTransitionStyle = route.transition
//        destination.modalPresentationStyle = .fullScreen
//        navigationController.present(destination, animated: true)
//    }
//
//    func goToWithParams(_ view: some View) {
//        let destination = UIHostingController(rootView: view)
//        destination.modalTransitionStyle = .coverVertical
//        navigationController.present(destination, animated: true)
//    }
//
//    func pushView(_ route: MediaRouter) {
//        let destination = route.view()
//        destination.modalPresentationStyle = .popover
//        navigationController.pushViewController(destination, animated: true)
//    }
//
//    func popView() {
//        print("pop!")
//        navigationController.popViewController(animated: true)
//    }
//
//    func popToRoot() {
//        navigationController.popToRootViewController(animated: true)
//    }
//
//    open func dismiss() {
//        navigationController.dismiss(animated: true) { [weak self] in
//            /// because there is a leak in UIHostingControllers that prevents from deallocation
//            self?.navigationController.viewControllers = self?.subviews ?? [UIViewController()]
//        }
//    }
//}
