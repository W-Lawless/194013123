//
//  WeatherAPI.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/17/22.
//

import Foundation

class WeatherApi: ObservableObject {
    
    @Published var condition: String = "Cloudy"
    @Published var currentTemp: Int = 0
    @Published var high: Int = 0
    @Published var low: Int = 0
    @Published var humidity: String = ""
    @Published var windSpeed: Int = 0
    @Published var sundown: String = ""
    
    private let scheme = "http"
    private let host = "10.0.0.41"
    private let baseApi = "/api/v1/destination/weather"
    private var endpoint: URL? {
        var URI = URLComponents()
        URI.scheme = self.scheme
        URI.host = self.host
        URI.path = "\(self.baseApi)"
        return URI.url
    }
    
    private var timer: Timer?
    
    func getWeather() async {
        
        guard let url = self.endpoint else {
            print(" ❌: Api Endpoint Malformed - Weather Info")
            return
        }
        
        do {
            let (data, _) = try await Session.shared.data(from: url)
            let serializedData = try? JSONDecoder().decode(NetworkResponse<WeatherModel>.self, from: data)
            
            if let model = serializedData {
                onHeartbeat(model: model)
            }
        } catch { print(" ❌: Weather Api Error: \(error)") }
    }
    
    func getWeatherDetails() async {
        
    }
    
    func heartbeatMonitor(interval: Double) {
        DispatchQueue.global(qos: .background).async {
            self.timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
                self.findHearbeat()
            }
            RunLoop.current.add(self.timer!, forMode: .common);
            RunLoop.current.run()
        }
    }
    
    func killMonitor() {
        DispatchQueue.global(qos: .background).async {
            self.timer?.invalidate()
        }
    }
    
    func findHearbeat() {
        
        guard let url = self.endpoint else {
            print(" ❌: Api Endpoint Malformed - Weather")
            return
        }
        
        var request = URLRequest(url: url, timeoutInterval: 12)
        request.httpMethod = "GET"
        
        let task = Session.shared.dataTask(with: request) { data, response, error in
            guard error == nil else { return }
            
            if let data = data {
                
                let serializedData = try? JSONDecoder().decode(NetworkResponse<WeatherModel>.self, from: data)
                
                if let model = serializedData {
                    self.onHeartbeat(model: model)
                }
            }
            
        }
        task.resume()
    }
    
    func onHeartbeat(model: NetworkResponse<WeatherModel>) {
        DispatchQueue.main.async {
            self.condition = model.results[0].current.condition
            self.currentTemp = Int(model.results[0].current.temperatureF)
            self.high =  model.results[0].current.high
            self.low = model.results[0].current.low
            self.humidity =  model.results[0].current.relativeHumidityPct
            self.windSpeed = Int(model.results[0].current.windMph)
            self.sundown =  model.results[0].astronomy.sunSet
        }
    }
}


