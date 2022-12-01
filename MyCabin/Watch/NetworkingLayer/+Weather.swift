//
//  Weather.swift
//  wearable Watch App
//
//  Created by Lawless on 11/14/22.
//

import Foundation

class WeatherAPI: ObservableObject {
    
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
            let serializedData = try! JSONDecoder().decode(WeatherModel.self, from: data)
            
//            if let model = serializedData {
//                onHeartbeat(model: model)
                self.onHeartbeat(model: serializedData)

//            }
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
                
                let serializedData = try! JSONDecoder().decode(WeatherModel.self, from: data)
                
//                if let model = serializedData {
//                    self.onHeartbeat(model: model)
                self.onHeartbeat(model: serializedData)
//                }
            }
            
        }
        task.resume()
    }
    
    func onHeartbeat(model: WeatherModel) {
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


struct WeatherModel: Codable {
    var results: [WeatherSubmodel]
    var length: Int
}

struct WeatherSubmodel: Codable {
    var current: RealtimeForecast
    var forecasts: [FutureForecast]
    var astronomy: Astronomy
}

struct RealtimeForecast: Codable {
    var condition: String
    var temperatureF: Float
    var high: Int
    var low: Int
    var relativeHumidityPct: String
    var windDirectionDeg: Int
    var windMph: Float
    var pressureIn: Float
    var pressureTrend: String
    var dewpointF: Int
    var heatIndexF: String
    var windChillF: String
    var visibilityMi: Float
    var solarRadiation: String
    var uv: String
    var probabilityOfPrecipitation: Int
}

struct FutureForecast: Codable {
    var date: Int64
    var highF: Int
    var lowF: Int
    var condition: String
    var probabilityOfPrecipitation: Int
    var quantitativePrecipitationForecastAllDayIn: Float
    var quantitativePrecipitationForecastDayIn: Float
    var quantitativePrecipitationForecastNightIn: Float
    var snowAllDayIn: Float
    var snowDayIn: Float
    var snowNightIn: Float
    var maxWindMph: Int
    var maxWindDirectionDeg: Int
    var avgWindMph: Int
    var avgWindDirectionDeg: Int
    var averageHumidityPct: Int
}

struct Astronomy: Codable {
    var moonPhasePctIlluminated: Int
    var ageOfMoon: Int
    var sunSet: String
    var sunRise: String
}
