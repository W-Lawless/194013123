//
//  RootView.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/17/22.
//

import SwiftUI

struct RootView: View {
    
    @ObservedObject var viewModel: RootViewModel
    let api: _CabinAPI
    
    @ViewBuilder
    var body: some View {
//        NavigationView {
            if(!viewModel.pulse) {
                Loading()
                    .onAppear() {
                        api.monitor?.startMonitor(interval: 3.5)
                    }
                    .onDisappear() {
                        api.monitor?.stopMonitor()
                    }
            } else {
                TabContainer()
                    .onAppear() {
                        api.monitor?.startMonitor(interval: 30.0)
                    }
                    .onDisappear() {
                        api.monitor?.stopMonitor()
                    }
            }
//        } //: NAV VIiew
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        ViewFactories.buildRootView()
    }
}
