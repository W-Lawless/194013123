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
    @Published var monitorsList = [MonitorModel]()
    
    func updateValues(_ data: [Codable]) {
        let monitors = data as? [MonitorModel]
        if let monitors {
            self.monitorsList = monitors
        }
    }
    
}
