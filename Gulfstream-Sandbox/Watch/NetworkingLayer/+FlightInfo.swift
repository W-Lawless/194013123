//
//  @FlightInfo.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/10/22.
//

import Foundation

class FlightViewModel: ObservableObject {
    @Published var groundSpeed: Int = 1
    @Published var airSpeed: Int = 1
    @Published var loading: Bool = true
    
    static let shared = FlightViewModel()
    static let api = FlightApi()
    
    private init() { }
    
    func setValues(groundSpeed: Int, airSpeed: Int){
       DispatchQueue.main.async {
           self.loading = false
           self.groundSpeed = groundSpeed
           self.airSpeed = airSpeed
       }
    }
}

class FlightApi {
        
    private let scheme = "http"
    private let host = "10.0.0.41"
    private let baseApi = "/api/v1/flightInfo"
    private var endpoint: URL? {
        var URI = URLComponents()
        URI.scheme = self.scheme
        URI.host = self.host
        URI.path = "\(self.baseApi)"
        return URI.url
    }
    
    private var timer: Timer?
    
    func getFlightDetails() async {
        
        guard let url = self.endpoint else { return }
        
        do {
            let (data, _) = try await Session.shared.data(from: url)
            let serializedData = try? JSONDecoder().decode(FlightModel.self, from: data)
            
            if let model = serializedData {
                FlightViewModel.shared.setValues(groundSpeed: model.results[0].ground_speed, airSpeed: model.results[0].air_speed)
            }
        } catch { print(" ❌: Flight Api Error: \(error)") }
    }
    
    func startMonitor(interval: Double) {
        DispatchQueue.global(qos: .background).async {
            self.timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
                self.pingEndpoint()
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
    
    func pingEndpoint() {
        
        guard let url = self.endpoint else { return }
        
        var request = URLRequest(url: url, timeoutInterval: 12)
        request.httpMethod = "GET"
        
        let task = Session.shared.dataTask(with: request) { data, response, error in
            guard error == nil else { return }
            
            if let data = data {
                let serializedData = try? JSONDecoder().decode(FlightModel.self, from: data)
                if let model = serializedData {
                    self.onHeartbeat(model: model)
                }
            }
        }
        task.resume()
    }
    
    func onHeartbeat(model: FlightModel) {
        DispatchQueue.main.async {
            FlightViewModel.shared.setValues(groundSpeed: model.results[0].ground_speed, airSpeed: model.results[0].air_speed)
        }
    }
}

struct FlightModel: Codable {
    var results: [FlightDetails]
    var length: Int
}

struct FlightDetails: Codable {
    var latitude: Double
    var longitude: Double
    var altitude: Int
    var air_speed: Int
    var ground_speed: Int
    var estimated_arrival: Int64
    var destination_timezone: String
    var time_remaining: Int64
    var current_time: Int64
    var total_time: Int64
    var external_temperature: Int
    var forward_cabin_temp: Int
    var aft_cabin_temp: Int
    var on_ground: Bool
    var mach: Double
    var mode: Bool
}

