//
//  FlightInterface.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/21/22.
//

import Foundation

//MARK: - API

struct FlightAPI {
    
    var viewModel: FlightViewModel
    let monitor = HeartBeatMonitor()
    
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
    }
    
    func initialFetch() async {
        do {
            let (data, _) = try await Session.shared.data(from: endpoint)
            let serializedData = try? JSONDecoder().decode(NetworkResponse<FlightModel>.self, from: data)
            if let model = serializedData { await viewModel.updateValues(true, model) }
        } catch { print(" ❌: Flight Api Error: \(error)") }
    }
    
    func monitorCallback() async {
        let request = URLRequest(url: self.endpoint, timeoutInterval: 2)
        
        do {
            let (data, _) = try await Session.shared.data(for: request)
            let serializedData = try? JSONDecoder().decode(NetworkResponse<FlightModel>.self, from: data)
            if let model = serializedData {
                print("Ground Speed: \(model.results[0].ground_speed)")
                await viewModel.updateValues(true, model)
            }
        }
        catch { await viewModel.updateValues(false, nil) }
    }
}
