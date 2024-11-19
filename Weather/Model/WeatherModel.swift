//
//  WeatherModel.swift
//  Weather
//
//  Created by Дмитрий Билинский on 11/11/24.
//

import Foundation

//MARK: - CoordinateModel -
struct CoordinateCity: Decodable {
  let lat: Float?
  let lon: Float?
}

//MARK: - WeatherModel -
struct WeatherModel: Decodable {
  let current: Current
  let hourly: [Hourly]
  let daily: [Daily]
}

//MARK: - Current -
struct Current: Decodable {
  let dt: Int?
  let sunrise: Int?
  let sunset: Int?
  let temp: Float?
  let feelsLike: Float?
  let pressure: Int?
  let humidity: Int?
  let dewPoint: Float?
  let uvi: Float?
  let clouds: Int?
  let visibility: Int?
  let windSpeed: Float?
  let windDeg: Int?
  let weather: [Weather]
  
  enum CodingKeys: String, CodingKey {
    case dt
    case sunrise
    case sunset
    case temp
    case feelsLike = "feels_like"
    case pressure
    case humidity
    case dewPoint = "dew_point"
    case uvi
    case clouds
    case visibility
    case windSpeed = "wind_speed"
    case windDeg = "wind_deg"
    case weather
  }
  
}

//MARK: - Hourly -
struct Hourly: Decodable {
  let dt: Int?
  let temp: Float?
  let feelsLike: Float?
  let pressure: Int?
  let humidity: Int?
  let dewPoint: Float?
  let uvi: Float?
  let clouds: Int?
  let visibility: Int?
  let windSpeed: Float?
  let windDeg: Int?
  let windGust: Float?
  let weather: [Weather]
  let pop: Float?
  
  enum CodingKeys: String, CodingKey {
    case dt
    case temp
    case feelsLike = "feels_like"
    case pressure
    case humidity
    case dewPoint = "dew_point"
    case uvi
    case clouds
    case visibility
    case windSpeed = "wind_speed"
    case windDeg = "wind_deg"
    case windGust = "wind_gust"
    case weather
    case pop
  }
  
}

//MARK: - Daily -
struct Daily: Decodable {
  let dt: Int?
  let sunrise: Int?
  let sunset: Int?
  let moonrise: Int?
  let moonset: Int?
  let temp: Temp
  let pressure: Int?
  let humidity: Int?
  let weather: [Weather]
}

struct Temp: Decodable {
  let day: Float?
  let min: Float?
  let max: Float?
  let night: Float?
  let eve: Float?
  let morn: Float?
}

struct Weather: Decodable {
  let id: Int?
  let main: String?
  let description: String?
  let icon: String?
}


