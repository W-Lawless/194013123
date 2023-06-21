//
//  AppDelegate.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/23/22.
//

import UIKit

final class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
//        if let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.path {
//            print("Documents Directory: \(documentsPath)")
//        }
        if CommandLine.arguments.contains("--uitesting") {
              
          }
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sessionRole = connectingSceneSession.role
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: sessionRole)
        sceneConfig.delegateClass = SceneDelegate.self
        return sceneConfig
    }
}


//MARK: - Scene


final class SceneDelegate: NSObject, UIWindowSceneDelegate {
        
    var appCoordinator: AppCoordinator?
    var hasAlreadyConnectedToCabin: Bool = false

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)

        let appCoordinator = AppCoordinator(window: window)
        ViewFactory.AppCoordinator = appCoordinator
        
        if CommandLine.arguments.contains("--uitesting") {
            appCoordinator.configureViews()
            try? FileCacheUtil.loadAllCaches()
            appCoordinator.goTo(.cabinFound)
        } else {
            appCoordinator.configureViews()
            appCoordinator.start { _ in } sinkValue: { cabinHeartBeat in
                DispatchQueue.main.async { [weak self] in
                    if(cabinHeartBeat){
                        self?.loadAllCabinElementsOnFirstConnection(cabinHeartBeat)
                        appCoordinator.goTo(.cabinFound)
                    } else {
                        appCoordinator.goTo(.loadCabin)
                    }
                }
            }
        }
        
        window.makeKeyAndVisible()
    }
    
    func loadAllCabinElementsOnFirstConnection(_ pulse: Bool) {
        if pulse != hasAlreadyConnectedToCabin {
            hasAlreadyConnectedToCabin = true
            PlaneFactory.connectToPlane()
        }
    }
}

