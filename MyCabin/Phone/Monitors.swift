//
//  Monitors.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/28/22.
//

import SwiftUI



//TODO: - Fix View Model somewhere
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
