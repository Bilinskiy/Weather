//
//  NetworkManager.swift
//  Weather
//
//  Created by Дмитрий Билинский on 11/11/24.
//

import Foundation

enum Language {
  case ru
  case en
  case be
  case fr
  case pl
}

enum Units {
  case standard
  case metric
  case imperial
}

protocol NetworkManagerProtocol {
  func getCoordinate(_ nameCity: String) async throws -> [CoordinateCity]
  func getWeather(_ coordinate: CoordinateCity) async throws
  func getIcon(_ icon: String) async throws -> Data
  var weatherData: WeatherModel? {get}
}

class NetworkManager: NetworkManagerProtocol {
  
  private let keyOpenWeather: String = {
    guard let key = Bundle.main.object(forInfoDictionaryKey: "OpenWeatherKey") as? String else { fatalError("keyOpenWeather not found") }
    return key
  }()
  
  var weatherData: WeatherModel?
  
  let lang: Language = .ru
  let units: Units = .metric
  
  func getCoordinate(_ nameCity: String) async throws -> [CoordinateCity] {
    guard let urlCoordinate = URL(string: "https://api.openweathermap.org/geo/1.0/direct?q=\(nameCity)&limit=1&appid=\(keyOpenWeather)") else {fatalError()}
    
    var request =  URLRequest(url: urlCoordinate)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let (data, _) = try await URLSession.shared.data(for: request)
    
    let coordinate = try JSONDecoder().decode([CoordinateCity].self, from: data)
    
    return coordinate
  }
  
  func getWeather(_ coordinate: CoordinateCity) async throws {
    guard let urlWeather = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(coordinate.lat!)&lon=\(coordinate.lon!)&units=\(units)&lang=\(lang)&exclude=minutely,alerts&appid=\(keyOpenWeather)") else {fatalError()}
    
    var request =  URLRequest(url: urlWeather)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let (data, _) = try await URLSession.shared.data(for: request)
    
    let weatherCity = try JSONDecoder().decode(WeatherModel.self, from: data)
    
    self.weatherData = weatherCity
  }
  
  func getIcon(_ icon: String) async throws -> Data {
    guard let urlIcon = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png") else {fatalError()}
    
    var request =  URLRequest(url: urlIcon)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let (data, _) = try await URLSession.shared.data(for: request)
    
    return data
  }
  
  
}
