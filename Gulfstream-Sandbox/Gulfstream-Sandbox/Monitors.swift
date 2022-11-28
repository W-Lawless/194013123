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
                    Text(monitor.name)
                }
            }
        }.onAppear {
            api.fetch()
        }
    }
    
}


class MonitorsViewModel: ObservableObject {
    
    @Published var loading: Bool = false
    @Published var monitorsList: [MonitorModel]?
    
    func updateValues(_ alive: Bool, _ data: [MonitorModel]?) {
        print("updating values with data")
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
