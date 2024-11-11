//
//  WeatherModel.swift
//  Weather
//
//  Created by Дмитрий Билинский on 11/11/24.
//

import Foundation

struct WeatherModel: Decodable {
  let weather: [Weather]
  let main: Main

}

struct Weather: Decodable {
  let id: Int
  let main: String
  let description: String
  let icon: String
}

struct Main: Decodable {
  let temp: Float
  let feelsLike: Float
  let tempMin: Float
  let tempMax: Float
  let pressure: Float
  let humidity: Float
  let seaLevel: Float
  let grndLevel: Float
  
  enum CodingKeys: String, CodingKey {
    case temp
    case feelsLike = "feels_like"
    case tempMin = "temp_min"
    case tempMax = "temp_max"
    case pressure
    case humidity
    case seaLevel = "sea_level"
    case grndLevel = "grnd_level"
    
  }
  
}

