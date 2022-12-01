//
//  Coordinator.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/27/22.
//

import SwiftUI
import Combine
import UIKit



public enum MenuRouter: NavigationRouter {
    
    case lights
    case shades
    case seats
    case climate
    case presets
    case settings
    case plane
    
    public var transition: NavigationTranisitionStyle {
        switch self {
        case .lights:
            return .push
        case .shades:
            return .push
        case .seats:
            return .presentModally
        default:
            return .push
        }
    }
    
    public func view(navCallback: @escaping () -> ()) -> UIViewController {
        switch self {
        case .lights:
           return UIHostingController(rootView: AppFactory.buildLightsView())
        case .shades:
            return UIHostingController(rootView: AppFactory.buildShadesView())
        case .seats:
            return UIHostingController(rootView: AppFactory.buildSeatSelection())
        case .climate:
            return UIHostingController(rootView: AppFactory.buildCabinClimateView())
        case .presets:
            return UIHostingController(rootView: Presets())
        case .settings:
            return UIHostingController(rootView: Settings())
        case .plane:
            return UIHostingController(rootView: PlaneSchematic())
        }
    }
}

public protocol NavigationRouter {

    var transition: NavigationTranisitionStyle { get }
    
    func view(navCallback: @escaping () -> ()) -> UIViewController
}

public enum NavigationTranisitionStyle {
    case push
    case presentModally
    case presentFullscreen
}

protocol CoordinatorSlim {
    func start()
}

protocol CoordinatorProtocol {

    var navigationController: UINavigationController { get }
    
    func start()
    func show(_ route: any NavigationRouter)
    func pop()
    func popToRoot()
    func dismiss()
}



//MARK: - Coordinator


open class Coordinator<Router: NavigationRouter>: ObservableObject {

    public let navigationController: UINavigationController
    public let startingRoute: Router?

    public init(navigationController: UINavigationController = .init(), startingRoute: Router? = nil) {
        self.navigationController = navigationController
        self.startingRoute = startingRoute
    }

    public func start() {
        print("opening. . .")
        guard let route = startingRoute else { return }
        show(route)
    }

    public func show(_ route: Router, animated: Bool = true) {
//        let view = route.view(navCallback: pop)
//        let viewWithCoordinator = view.environmentObject(self)
//        let viewController = UIHostingController(rootView: viewWithCoordinator)
//        switch route.transition {
//        case .push:
//            navigationController.pushViewController(viewController, animated: animated)
//        case .presentModally:
//            viewController.modalPresentationStyle = .formSheet
//            navigationController.present(viewController, animated: animated)
//        case .presentFullscreen:
//            viewController.modalPresentationStyle = .fullScreen
//            navigationController.present(viewController, animated: animated)
//        }
    }

    public func pop() {
        navigationController.popViewController(animated: true)
    }

    public func popToRoot(animated: Bool = true) {
        navigationController.popToRootViewController(animated: animated)
    }

    open func dismiss(animated: Bool = true) {
        navigationController.dismiss(animated: true) { [weak self] in
            /// because there is a leak in UIHostingControllers that prevents from deallocation
            self?.navigationController.viewControllers = []
        }
    }
}

