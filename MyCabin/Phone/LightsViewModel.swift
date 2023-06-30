//
//  LightsViewModel.swift
//  MyCabin
//
//  Created by Lawless on 6/28/23.
//

import SwiftUI

class LightsViewModel: ObservableObject {
    
    typealias F = EndpointFormats.Get
    typealias R = LightModel.state
    
    @Published var activeSeat: String = ""
    @Published var lightList: [LightModel]?
    @Published var showPanel: Bool = false
    @Published var rtResponses = [String:R]()
    @Published var lightsForSeat = [LightModel]()
    
    var rtAPI = [RealtimeAPI<F ,R>]()
    var allSeats = [SeatModel]()
    
    func updateValues(_ data: [Codable]) {
        let typecast = data as? [LightModel]
        if let typecast {
            self.lightList = typecast
        }
    }
    
    func updateSeats(_ seats: [SeatModel]) {
        self.allSeats = seats
    }
    
    func getLightsForSeat() {
        let target = allSeats.filter { seat in
            return seat.id == activeSeat
        }

        if let seatLights = target.first?.lights {
            lightsForSeat = seatLights
        }
    }
    
    func showSubView(forID seat: String) {
        if(activeSeat != seat){
            showPanel = true
            activeSeat = seat
        } else {
            showPanel.toggle()
        }
    }
    
    
    func pollLightsForState(lights: [LightModel]) {
        
        lights.forEach { light in
            let ep = Endpoint<F, R>(path: .lights, stateUpdate: light.id)
            
            let client =  RealtimeAPI(endpoint: ep) { [weak self] apiResult in
                if let state = apiResult.first {
                    self?.rtResponses[light.id] = state
                }
            }
            
            rtAPI.append(client)
            
            client.monitor.startMonitor(interval: 1.0, callback: client.monitorCallback)
        }
    }
    
    func killMonitor() {
        print("KILL MONITOR!")
        self.rtAPI.forEach({ rtApiClient in
            rtApiClient.monitor.stopMonitor()
        })
    }
    
    
    
}
