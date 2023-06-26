//
//  FlightInfo.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/9/22.
//

import SwiftUI
import Combine

struct FlightInfo: View {
    
    @ObservedObject var viewModel: FlightViewModel

    var startMonitor: (Double, @escaping () async -> Void) -> Void
    var monitorCallback: () async -> Void
    var stopMonitor: () -> Void
    
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
        .onAppear() {
            startMonitor(3.0, monitorCallback)
        }
        .onDisappear() {
            stopMonitor()
        }
    }
}

//MARK: - View Model

class FlightViewModel: ObservableObject, GCMSViewModel {
        
    @Published var loading: Bool = true
    @Published var groundSpeed: Int?
    @Published var airSpeed: Int?
    
    func updateValues(_ data: [Codable]) {
        self.loading = false
        if let data = data as? [FlightModel] {
            self.groundSpeed = data[0].ground_speed
            self.airSpeed = data[0].air_speed
        }
    }

}
