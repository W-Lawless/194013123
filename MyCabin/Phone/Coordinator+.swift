//
//  Coordinator.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/27/22.
//

import SwiftUI
import UIKit

protocol MenuCoordinatorProtocol<R> {
    associatedtype R
    var navigationController: UINavigationController { get }
    func start<T>(subviews: [UIHostingController<T>])
    func goTo(_ route: R)
    func popView()
    func popToRoot()
    func dismiss()
}

protocol Coordinator {
    func start()
}
