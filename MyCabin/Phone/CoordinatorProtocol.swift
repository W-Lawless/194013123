//
//  Coordinator.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/27/22.
//

import UIKit

protocol Coordinator<R> {
    associatedtype R
    var navigationController: UINavigationController { get }
    func start(subviews: [UIViewController])
    func goTo(_ route: R)
    func popView()
    func popToRoot()
    func dismiss()
}
