//
//  WeatherData.swift
//  GetWeather
//
//  Created by Prashuk Ajmera on 6/11/21.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let weather: [Weather]
    let main: Main
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
}

struct Main: Codable {
    let temp: Double
    let feels_like: Double
    let humidity: Double
}
