//
//  Weather.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/22/22.
//

import SwiftUI

struct Weather: View {
    
    @StateObject var viewModel: WeatherViewModel
    var api: WeatherApi
    
    var body: some View {
        List{
            HStack {
                Text("Weather Conditions:")
                Text("\(viewModel.condition)")
            }
            HStack {
                Text("Current:")
                Text("\(viewModel.currentTemp)")
            }
            HStack {
                Text("H:")
                Text("\(viewModel.high)")
            }
            HStack {
                Text("L:")
                Text("\(viewModel.low)")
            }
            HStack {
                Text("Humidity")
                Text("\(viewModel.humidity)%")
            }
            HStack {
                Text("Wind Speed:")
                Text("\(viewModel.windSpeed)mph")
            }
            HStack {
                Text("Sundown:")
                Text("\(viewModel.sundown)")
            }
        }
//        .onAppear {
//            api.fetch()
//        }
    }
}

//MARK: - View Model

class WeatherViewModel: ObservableObject {
    
    @Published var condition: String = "Cloudy"
    @Published var currentTemp: Int = 0
    @Published var high: Int = 0
    @Published var low: Int = 0
    @Published var humidity: String = ""
    @Published var windSpeed: Int = 0
    @Published var sundown: String = ""
    
    func updateValues(_ alive: Bool, _ data: WeatherModel?) {
        if let data = data {
            self.condition = data.current.condition
            self.currentTemp = Int(data.current.temperatureF)
            self.high =  data.current.high
            self.low = data.current.low
            self.humidity =  data.current.relativeHumidityPct
            self.windSpeed = Int(data.current.windMph)
            self.sundown =  data.astronomy.sunSet
        }
    }
}

//MARK: - Preview

struct Weather_Previews: PreviewProvider {
    static var previews: some View {
        ViewFactories.buildWeatherView()
    }
}
