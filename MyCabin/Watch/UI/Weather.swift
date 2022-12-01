//
//  CallAttendant.swift
//  wearable Watch App
//
//  Created by Lawless on 11/9/22.
//

import SwiftUI

struct Weather: View {
    
    @ObservedObject var api = WeatherAPI()
    
    var body: some View {
        List{
            HStack {
                Text("Weather Conditions:")
                Text("\(api.condition)")
            }
            HStack {
                Text("Current:")
                Text("\(api.currentTemp)")
            }
            HStack {
                Text("H:")
                Text("\(api.high)")
            }
            HStack {
                Text("L:")
                Text("\(api.low)")
            }
            HStack {
                Text("Humidity")
                Text("\(api.humidity)%")
            }
            HStack {
                Text("Wind Speed:")
                Text("\(api.windSpeed)mph")
            }
            HStack {
                Text("Sundown:")
                Text("\(api.sundown)")
            }
        }
        .task {
            await api.getWeather()
        }
    }
}

struct Weather_Previews: PreviewProvider {
    static var previews: some View {
        Weather()
    }
}
