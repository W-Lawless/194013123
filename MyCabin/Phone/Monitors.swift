//
//  Monitors.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/28/22.
//

import SwiftUI

//TODO: - Remove Entire view ? 
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
    @Published var selectedMonitor: MonitorModel?
    @Published var playingMonitors: [String:String] = ["-":"-"]
    
    func updateValues(_ data: [Codable]) {
        self.monitorsList = data as? [MonitorModel]
    }
    
    func updatePlayingMonitors(monitor: MonitorModel, source: SourceModel) {
        playingMonitors[monitor.id] = source.id
    }
    
}
