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
        
    var window: UIWindow?
    var hasAlreadyConnectedToCabin: Bool = false
    
    let apiFactory: APIFactory
    let stateFactory: StateFactory
    let cacheUtil: FileCacheUtil
    let viewFactory: ViewFactory
    let navigationFactory: NavigationFactory
    
    override init() {
        self.apiFactory = APIFactory()
        self.cacheUtil = FileCacheUtil()
        self.stateFactory = StateFactory(api: self.apiFactory, cache: self.cacheUtil)
        self.viewFactory = ViewFactory(api: self.apiFactory, state: self.stateFactory)
        self.navigationFactory = NavigationFactory(views: self.viewFactory, rootTabCoordinator: self.stateFactory.rootTabCoordinator, homeMenuCoordinator: self.stateFactory.homeMenuCoordinator)
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        
        if let window {
            let app = readyApplication(window: window)
            
//            let screenWidth = window.windowScene?.screen.bounds.width
//            let screenHeight = window.windowScene?.screen.bounds.height
//
//            stateFactory.planeViewModel.containerViewWidth = screenWidth!
//            stateFactory.planeViewModel.containerViewHeight = screenHeight!
            //TODO: - pass into state factory ?
            
            launch(app)
            window.makeKeyAndVisible()
        }
        
    }
    
    func readyApplication(window: UIWindow) -> AppCoordinator {
        let app = AppCoordinator(cabinAPI: apiFactory.cabinAPI, loadingView: viewFactory.buildUIHostedLoadingScreen(), rootTabCoordinator: stateFactory.rootTabCoordinator, window: window)
        configureNavigationControllers()
        app.configureViews()
        return app
    }
    
    func configureNavigationControllers() {
        navigationFactory.configureRootTabCoordinator()
    }
    
    func launch(_ app: AppCoordinator) {
        if CommandLine.arguments.contains("--uitesting") {
            launchUITests(app)
        } else {
            #if DEBUG
            launchDevelopment(app)
            #else
            launchProduction(app)
            #endif
        }
    }

    func launchUITests(_ app: AppCoordinator) {
        print("LAUNCH UI TESTING")
        try? self.stateFactory.loadAllCaches()
        app.goTo(.cabinFound)
    }
    
    func launchDevelopment(_ app: AppCoordinator) {
        print("LAUNCH DEVELOPMENT")
        try? self.stateFactory.loadAllCaches()
        app.goTo(.cabinFound)
    }
    
    func launchProduction(_ app: AppCoordinator) {
        app.start(publisher: apiFactory.cabinConnectionPublisher, tokenStore: &apiFactory.cancelTokens) { _ in } sinkValue: { cabinHeartBeat in
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
            self.stateFactory.connectToPlane()
        }
    }
    
}
