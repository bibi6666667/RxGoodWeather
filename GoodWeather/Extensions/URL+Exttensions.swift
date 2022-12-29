//
//  URL+Exttensions.swift
//  GoodWeather
//
//  Created by Bibi on 2022/12/28.
//

import Foundation

extension URL {
    static func urlForWeatherAPI(city: String) -> URL? {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=API키&units=metric"
        return URL(string: urlString)
    
    }
}
