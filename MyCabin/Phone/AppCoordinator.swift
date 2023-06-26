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
    let cabin: CabinAPIAdaptor
    var loadingView: CabinLoadingView
    var tabs: RootTabCoordinator
    let rootNavView = UINavigationController()
    
    init(window: UIWindow,
         cabin: CabinAPIAdaptor = PlaneFactory.cabinAPI,
         loadingView: CabinLoadingView = ViewFactory.loadingView,
         tabCoordinator: RootTabCoordinator = NavigationFactory.buildRootTabNavigation()
    ) {
        self.window = window
        self.cabin = cabin
        self.loadingView = loadingView
        self.tabs = tabCoordinator
    }
    
    func configureViews() {
        rootNavView.navigationBar.isHidden = true
        rootNavView.setViewControllers([tabs.navigationController,loadingView], animated: true)
        self.window.rootViewController = rootNavView
    }
    
    func start(
        publisher: CabinPublisher = PlaneFactory.cabinConnectionPublisher,
        sinkCompletion endSink: @escaping SinkCompletion,
        sinkValue onSink: @escaping SinkValue) {
            publisher.sink(receiveCompletion: endSink, receiveValue: onSink).store(in: &PlaneFactory.cancelTokens)
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
        cabin.monitor.stopMonitor()
        cabin.monitor.startMonitor(interval: interval, callback: cabin.monitorCallback)
    }
 
    enum AppRouter {
        case cabinFound
        case loadCabin
    }
}
