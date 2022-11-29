//
//  Monitors.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/28/22.
//

import SwiftUI

struct Monitors: View {
    
    @StateObject var viewModel: MonitorsViewModel
    var api: MonitorsAPI
    
    var body: some View {
        Group{
            if (viewModel.loading) {
                ProgressView()
            } else {                
                List(viewModel.monitorsList ?? [MonitorModel]()) { monitor in
                    Group {
                        Text(monitor.id)
                        Button("Power On") {
                            api.togglePower(monitor, cmd: true)
                        }
                        Button("Power Off") {
                            api.togglePower(monitor, cmd: false)
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


class MonitorsViewModel: ObservableObject {
    
    @Published var loading: Bool = false
    @Published var monitorsList: [MonitorModel]?
    
    func updateValues(_ alive: Bool, _ data: [MonitorModel]?) {
        self.loading = !alive
        if let data = data {
            self.monitorsList = data
        }
    }
    
}


struct Monitors_Previews: PreviewProvider {
    static var previews: some View {
        ViewFactories.buildMonitorsView()
    }
}
