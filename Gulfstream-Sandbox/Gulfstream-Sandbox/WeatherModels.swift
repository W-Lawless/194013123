//
//  WeatherModels.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/17/22.
//

import Foundation

//struct WeatherModel: Codable {
//    var results: [WeatherSubmodel]
//    var length: Int
//}

struct WeatherModel: Codable {
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
