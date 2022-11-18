//
//  FlightInfo.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/9/22.
//

import SwiftUI

struct FlightInfo: View {
    
    @ObservedObject var viewModel: FlightViewModel
    var api: FlightAPI
    
    var body: some View {
        List {
            if(viewModel.loading) {
                ProgressView()
            } else {
                HStack{
                    Text("Ground Speed")
                    Text("\(viewModel.groundSpeed ?? 0)")
                }
                
                HStack{
                    Text("Air Speed")
                    Text("\(viewModel.airSpeed ?? 0)")
                }
            }
        }
        .task {
            await api.initialFetch()
        }
        .onAppear() {
            api.monitor.startMonitor(interval: 3.0)
        }
        .onDisappear() {
            api.monitor.stopMonitor()
        }
    }
}

//MARK: - View Model

class FlightViewModel: ObservableObject {
        
    @Published var loading: Bool = true
    @Published var groundSpeed: Int?
    @Published var airSpeed: Int?
    
    @MainActor func updateValues(_ alive: Bool, _ data: NetworkResponse<FlightModel>?) {
        self.loading = false
        self.groundSpeed = data?.results[0].ground_speed
        self.airSpeed = data?.results[0].air_speed
    }

}

//MARK: - Preview

struct FlightInfo_Previews: PreviewProvider {
    static var previews: some View {
        ViewFactories.buildFlightInfo()
    }
}
