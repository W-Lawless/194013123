//
//  FlightInfo.swift
//  wearable Watch App
//
//  Created by Lawless on 11/9/22.
//

import SwiftUI

struct FlightInfo: View {
    
    @ObservedObject var viewModel = FlightViewModel.shared
    
    var body: some View {
        List {
            HStack{
                Text("Ground Speed")
                if(viewModel.loading){
                    ProgressView()
                } else {
                    Text("\(viewModel.groundSpeed)")
                }
            }
            
            HStack{
                Text("Air Speed")
                if(viewModel.loading){
                    ProgressView()
                } else {
                    Text("\(viewModel.airSpeed)")
                }
            }
        }
        .task {
            await FlightViewModel.api.getFlightDetails()
        }
        .onAppear() {
            FlightViewModel.api.startMonitor(interval: 2.0)
        }
        .onDisappear() {
            FlightViewModel.api.stopMonitor()
        }
    }
}

struct FlightInfo_Previews: PreviewProvider {
    static var previews: some View {
        FlightInfo()
    }
}
