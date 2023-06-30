//
//  AppCoordinator.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/27/22.
//

import UIKit
import SwiftUI
import Combine

class AppCoordinator {
    
    typealias CabinAPIAdaptor = CabinAPI<EndpointFormats.Head, EmptyResponse>
    typealias CabinLoadingView = UIHostingController<Loading>
    typealias CabinPublisher = CurrentValueSubject<Bool, Never>
    typealias SinkCompletion = (Subscribers.Completion<Never>) -> Void
    typealias SinkValue =  (Bool) -> Void
    
    let window: UIWindow
    let cabinAPI: CabinAPIAdaptor
    var loadingView: CabinLoadingView
    var tabs: RootTabCoordinator
    let rootNavView = UINavigationController()
    
    init(cabinAPI: CabinAPIAdaptor,
         loadingView: CabinLoadingView,
         rootTabCoordinator: RootTabCoordinator,
         window: UIWindow
    ) {
        self.cabinAPI = cabinAPI
        self.loadingView = loadingView
        self.tabs = rootTabCoordinator
        self.window = window
    }
    
    func configureViews() {
        rootNavView.navigationBar.isHidden = true
        rootNavView.setViewControllers([tabs.tabBarController,loadingView], animated: false)
        self.window.rootViewController = rootNavView
    }
    
    func start(
        publisher: CabinPublisher,
        tokenStore: inout Set<AnyCancellable>,
        sinkCompletion endSink: @escaping SinkCompletion,
        sinkValue onSink: @escaping SinkValue) {
            publisher.sink(receiveCompletion: endSink, receiveValue: onSink).store(in: &tokenStore)
    }
    
    func goTo(_ route: AppRouter) {
        switch route {
        case .cabinFound:
            startMonitor(atInterval: 30.0)
            if(rootNavView.visibleViewController === loadingView) { ///Check view order
                rootNavView.popViewController(animated: true)
            }
        case .loadCabin:
            startMonitor(atInterval: 3.0)
            if(rootNavView.visibleViewController !== loadingView) { /// Check already loading
                rootNavView.pushViewController(loadingView, animated: true)
            }
        }
    }
    
    func startMonitor(atInterval interval: Double){
        cabinAPI.monitor.stopMonitor()
        cabinAPI.monitor.startMonitor(interval: interval, callback: cabinAPI.monitorCallback)
    }
 
    enum AppRouter {
        case cabinFound
        case loadCabin
    }
}
