//
//  MonitorsAPI.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/28/22.
//

import Combine

extension GCMSClient {
    
    func toggleMonitor(_ monitor: MonitorModel, cmd: Bool) {
        
        let endpoint = Endpoint<EndpointFormats.Put<MonitorPowerState>, MonitorModel.state>(path: .monitors, stateUpdate: monitor.id)
        let encodeObj = MonitorPowerState(on: cmd)
            
        let callback = { monitorStatus in
            print("put request data", monitorStatus)
        }
        
        self.put(for: endpoint, putData: encodeObj, callback: callback)
    }
    
    
    func assignSourceToMonitor(_ monitor: MonitorModel, source: SourceModel) {
        
        let endpoint = Endpoint<EndpointFormats.Put<MonitorSourceAssignment>, MonitorModel.state>(path: .monitors, stateUpdate: monitor.id)
        let encodeObj = MonitorSourceAssignment(source: source.id)
            
        let callback = { monitorStatus in
            print("put request data", monitorStatus)
        }
        
        self.put(for: endpoint, putData: encodeObj, callback: callback)
    }
}

