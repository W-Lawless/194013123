//
//  TestAppDelegate.swift
//  Tests
//
//  Created by Lawless on 6/19/23.
//

//import UIKit
//import Combine
//@testable import MyCabin
//
//@objc(TestAppDelegate)
//final class TestAppDelegate: NSObject, UIApplicationDelegate {
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
//        print(">>> LAUNCHING TESTS WITH MOCK APP DELEGATE :: DESTROYING CACHED SCENES")
//        for sceneSession in application.openSessions {
//            application.perform(Selector(("_removeSessionFromSessionSet:")), with: sceneSession)
//        }
//
//        return true
//    }
//
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        print(">>> CONFIGURING TEST SCENE DELEGATE")
//        let sessionRole = connectingSceneSession.role
//        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: sessionRole)
//        sceneConfig.delegateClass = TestSceneDelegate.self
//        return sceneConfig
//    }
//}
//
//
////MARK: - Scene
//
//
//final class TestSceneDelegate: NSObject, UIWindowSceneDelegate {
//
//    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        guard let windowScene = (scene as? UIWindowScene) else { return }
//        let window = UIWindow(windowScene: windowScene)
//        print(">>> LAUNCHING TESTS IN MOCK SCENE WINDOW")
//
//
//        window.makeKeyAndVisible()
//    }
//}

