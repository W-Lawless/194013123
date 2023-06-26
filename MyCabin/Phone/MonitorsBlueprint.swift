//
//  MonitorsBlueprint.swift
//  MyCabin
//
//  Created by Lawless on 6/22/23.
//

import SwiftUI

//TODO: Remove static references
struct MonitorsBlueprint: View {
    
    let area: PlaneArea
    
    @ObservedObject var mediaViewModel = StateFactory.mediaViewModel
    
    var body: some View {
        ForEach(area.monitors ?? [MonitorModel]()) { monitor in
            if(monitor.id == mediaViewModel.selectedMonitor) {
                MonitorButton(monitor: monitor, selected: true)
                    .modifier(PlaceIcon(rect: monitor.rect))
            } else {
                MonitorButton(monitor: monitor, selected: false)
                    .modifier(PlaceIcon(rect: monitor.rect))
            }
        }
    }
}


