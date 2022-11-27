//
//  AppCoordinator.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/27/22.
//

import SwiftUI
import UIKit

class AppCoordinator: Coordinator {
    
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        window.rootViewController = UIHostingController(rootView: Home())
    }
}
