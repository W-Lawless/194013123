//
//  AppDelegate.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/23/22.
//

import UIKit

@main
final class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
///        if let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.path {
///            print("Documents Directory: \(documentsPath)")
///        }
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sessionRole = connectingSceneSession.role
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: sessionRole)
        sceneConfig.delegateClass = SceneDelegate.self
        return sceneConfig
    }
}


final class SceneDelegate: NSObject, UIWindowSceneDelegate {
        
    var appCoordinator: AppCoordinator?
    var hasAlreadyConnectedToCabin: Bool = false
    
    let stateFactory: StateFactory
    let cacheUtil: FileCacheUtil
    let planeFactory: PlaneFactory
    let viewFactory: ViewFactory
    let navigationFactory: NavigationFactory
    
    override init() {
        self.stateFactory = StateFactory()
        self.cacheUtil = FileCacheUtil(state: self.stateFactory)
        self.planeFactory = PlaneFactory(state: self.stateFactory, cacheUtil: self.cacheUtil)
        self.viewFactory = ViewFactory(state: self.stateFactory, plane: self.planeFactory)
        self.navigationFactory = NavigationFactory(views: self.viewFactory, rootTabCoordinator: self.stateFactory.rootTabCoordinator, homeMenuCoordinator: self.stateFactory.homeMenuCoordinator)
        super.init()
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        let app = readyApplication(window: window)
        launch(app)
        
        window.makeKeyAndVisible()
    }
    
    func readyApplication(window: UIWindow) -> AppCoordinator {
        let app = AppCoordinator(cabinAPI: planeFactory.cabinAPI, loadingView: viewFactory.buildUIHostedLoadingScreen(), rootTabCoordinator: stateFactory.rootTabCoordinator, window: window)
        configureNavigationControllers()
        app.configureViews()
        return app
    }
    
    
    func configureNavigationControllers() {
        _ = self.navigationFactory.buildRootTabNavigation()
        _ = self.navigationFactory.buildHomeMenu()
    }
    
    func launch(_ app: AppCoordinator) {
        if CommandLine.arguments.contains("--uitesting") {
            launchUITests(app)
        } else {
            launchProduction(app)
        }
    }

    func launchUITests(_ app: AppCoordinator) {
        print("UI TESTS LAUNCHED")
        app.configureViews()
        try? cacheUtil.loadAllCaches()
        app.goTo(.cabinFound)
    }
    
    func launchProduction(_ app: AppCoordinator) {
        
        app.start(publisher: planeFactory.cabinConnectionPublisher, tokenStore: &stateFactory.cancelTokens) { _ in } sinkValue: { cabinHeartBeat in
            DispatchQueue.main.async { [weak self] in
                if(cabinHeartBeat){
                    self?.loadAllCabinElementsOnFirstConnection(cabinHeartBeat)
                    app.goTo(.cabinFound)
                } else {
                    app.goTo(.loadCabin)
                }
            }
        }
    }
    
    func loadAllCabinElementsOnFirstConnection(_ pulse: Bool) {
        if pulse != hasAlreadyConnectedToCabin {
            hasAlreadyConnectedToCabin = true
            self.planeFactory.connectToPlane()
        }
    }
    
}

protocol ApplicationWindow {}
extension UIWindow: ApplicationWindow {}
