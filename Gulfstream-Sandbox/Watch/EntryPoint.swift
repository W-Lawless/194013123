//
//  wearableApp.swift
//  wearable Watch App
//
//  Created by Lawless on 11/9/22.
//

import SwiftUI

@main
struct wearable_Watch_AppApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    @ObservedObject var cabin = CabinHeartbeat()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if(!cabin.pulse) {
                    Loading()
                        .onAppear() {
                            cabin.startMonitor(interval: 3.5)
                        }
                        .onDisappear() {
                            cabin.stopMonitor()
                        }
                } else {
                    TabContainer()
                        .environmentObject(cabin)
                        .onAppear() {
                            cabin.startMonitor(interval: 30.0)
                        }
                        .onDisappear() {
                            cabin.stopMonitor()
                        }
                }
            }
            .navigationViewStyle(.stack)
        }
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
