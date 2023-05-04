//
//  Monitors.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/28/22.
//

import SwiftUI

struct Monitors: View {
    
    @StateObject var viewModel: MonitorsViewModel
    
    var body: some View {
        Group{
            if (viewModel.loading) {
                ProgressView()
            } else {                
                List(viewModel.monitorsList ?? [MonitorModel]()) { monitor in
                    Group {
                        Text(monitor.id)
                        Button("Power On") {
                            StateFactory.apiClient.toggleMonitor(monitor, cmd: true)
                        }
                        Button("Power Off") {
                            StateFactory.apiClient.toggleMonitor(monitor, cmd: false)
                        }
                    }
                }
            }
        }
//        .onAppear {
//            api.fetch()
//        }
    }
    
}


class MonitorsViewModel: ObservableObject, GCMSViewModel {
    
    @Published var loading: Bool = false
    @Published var monitorsList: [MonitorModel]?
    
    func updateValues(_ data: [Codable]) {
        self.monitorsList = data as? [MonitorModel]
    }
}


struct Monitors_Previews: PreviewProvider {
    static var previews: some View {
        ViewFactory.buildMonitorsView()
    }
}
