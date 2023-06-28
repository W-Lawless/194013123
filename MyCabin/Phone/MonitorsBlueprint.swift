//
//  MonitorsBlueprint.swift
//  MyCabin
//
//  Created by Lawless on 6/22/23.
//

import SwiftUI

struct MonitorsBlueprint: View, AreaBlueprint {
    
    @EnvironmentObject var mediaViewModel: MediaViewModel

    let areaMonitors: [MonitorModel]
    let monitorButtonBuilder: (MonitorModel, Bool) -> MonitorButton
    
    var body: some View {
        ForEach(areaMonitors) { monitor in
            if(monitor.id == mediaViewModel.selectedMonitor) {
                monitorButtonBuilder(monitor, true)
                    .modifier(PlaceIcon(rect: monitor.rect))
            } else {
                monitorButtonBuilder(monitor, false)
                    .modifier(PlaceIcon(rect: monitor.rect))
            }
        }
    }
}


