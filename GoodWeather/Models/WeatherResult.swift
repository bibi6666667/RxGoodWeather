//
//  WeatherResult.swift
//  GoodWeather
//
//  Created by Bibi on 2022/12/28.
//

import Foundation

struct WeatherResult: Decodable {
    let main: Weather
}

struct Weather: Decodable {
    let temp: Double
    let humidity: Double
}
