//
//  FlightInterface.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/15/22.
//

import Foundation

//MARK: - API

struct FlightAPI {
    
    private var viewModel: FlightViewModel
    var monitor: any HeartbeatMonitor
    
    private let scheme = "http"
    private let host = "10.0.0.41"
    private let baseApi = "/api/v1/flightInfo"
    private var endpoint: URL
    
    init(viewModel: FlightViewModel) {
        var URI = URLComponents()
        URI.scheme = self.scheme
        URI.host = self.host
        URI.path = "\(self.baseApi)"
        self.endpoint = URI.url!
        self.viewModel = viewModel
        self.monitor = FlightMonitor(endpoint: endpoint, callBack: viewModel.updateValues)
    }
    
    func initialFetch() async {
        do {
            let (data, _) = try await Session.shared.data(from: endpoint)
            let serializedData = try? JSONDecoder().decode(FlightModel.self, from: data)
            if let model = serializedData { await viewModel.updateValues(true, model) }
        } catch { print(" ❌: Flight Api Error: \(error)") }
    }
}


//MARK: - Monitor

class FlightMonitor: HeartbeatMonitor {
    
    private var endpoint: URL
    private var timer: Timer?
    var onPulse: (Bool, FlightModel?) async -> ()
    
    init(endpoint url: URL, callBack cb: @escaping (_: Bool, _: FlightModel?) async -> ()) {
        self.endpoint = url
        self.onPulse = cb
    }
    
    func startMonitor(interval: Double) {
        DispatchQueue.global(qos: .background).async {
            self.timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
                Task {
                    print("Calling flight monitor at \(interval)")
                    await self.findPulse()
                }
            }
            RunLoop.current.add(self.timer!, forMode: .common);
            RunLoop.current.run()
        }
    }
    
    func stopMonitor() {
        DispatchQueue.global(qos: .background).async {
            self.timer?.invalidate()
        }
    }

    func findPulse() async {
        
        let request = URLRequest(url: self.endpoint, timeoutInterval: 2)
        
        do {
            let (data, _) = try await Session.shared.data(for: request)
            let serializedData = try? JSONDecoder().decode(FlightModel.self, from: data)
            if let model = serializedData {
                await self.onPulse(true, model)
            }
        }
        catch { await self.onPulse(false, nil) }
    }

}
