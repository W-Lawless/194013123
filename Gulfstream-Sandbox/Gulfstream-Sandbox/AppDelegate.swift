//
//  AppDelegate.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/23/22.
//

import Foundation
import UIKit
import SwiftUI


@main
final class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        return true
    }
    
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let sessionRole = connectingSceneSession.role
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: sessionRole)
        sceneConfig.delegateClass = SceneDelegate.self
        return sceneConfig
    }
}


//MARK: - Scene


final class SceneDelegate: NSObject, UIWindowSceneDelegate {
        
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let appCoordinator = AppCoordinator(window: window)
        appCoordinator.start()
        self.appCoordinator = appCoordinator
        window.makeKeyAndVisible()
    }
}


//MARK: - Coordinator

/*
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
        let view = route.view()
        let viewWithCoordinator = view.environmentObject(self)
        let viewController = UIHostingController(rootView: viewWithCoordinator)
        switch route.transition {
        case .push:
            navigationController.pushViewController(viewController, animated: animated)
        case .presentModally:
            viewController.modalPresentationStyle = .formSheet
            navigationController.present(viewController, animated: animated)
        case .presentFullscreen:
            viewController.modalPresentationStyle = .fullScreen
            navigationController.present(viewController, animated: animated)
        }
    }
    
    public func pop(animated: Bool = true) {
        navigationController.popViewController(animated: animated)
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
*/

//MARK: - Protocols & Enums
/*
protocol CoordinatorProtocol {

    var navigationController: UINavigationController { get }
    
    func start()
    func show(_ route: any NavigationRouter)
    func pop()
    func popToRoot()
    func dismiss()
}

public enum Router: NavigationRouter {
    
    case lights
    case shades
    case home
    
    public var transition: NavigationTranisitionStyle {
        switch self {
        case .lights:
            return .push
        case .shades:
            return .push
        case .home:
            return .push
        }
    }
    
    @ViewBuilder
    public func view() -> some View {
        switch self {
        case .lights:
            ViewFactories.buildLightsView()
        case .shades:
            ViewFactories.buildShadesView()
        case .home:
            Home()
        }
    }
}

public protocol NavigationRouter {
    associatedtype V: View

    var transition: NavigationTranisitionStyle { get }
    
    @ViewBuilder
    func view() -> V
}

public enum NavigationTranisitionStyle {
    case push
    case presentModally
    case presentFullscreen
}
*/
