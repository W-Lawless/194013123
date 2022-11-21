//
//  Gulfstream_SandboxApp.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless Sharpe on 11/3/22.
//

import SwiftUI

@main
struct Gulfstream_SandboxApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    @StateObject var cabin = CabinAPI()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if(!cabin.pulse) {
                    Loading()
                        .onAppear() {
                            cabin.monitor.startMonitor(interval: 3.0, callback: cabin.monitorCallback)
                        }
                        .onDisappear() {
                            cabin.monitor.stopMonitor()
                        }
                } else {
                    TabContainer()
                        .onAppear() {
                            cabin.monitor.startMonitor(interval: 30.0, callback: cabin.monitorCallback)
                        }
                        .onDisappear() {
                            cabin.monitor.stopMonitor()
                        }
                }
            } //: NAV
        } //: WINDOW
        .onChange(of: scenePhase) { scenePhase in
            switch scenePhase {
            case .background:
                print(" 💤 App in background.")
            case .inactive:
                print(" 🪑 App inactive.")
            case .active:
                print(" 🏃‍♂️ App active.")
            @unknown default:                       ///Future-proofing
                print("App changed scene phase.")
            }
        }
    }
}
