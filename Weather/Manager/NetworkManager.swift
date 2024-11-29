//
//  NetworkManager.swift
//  Weather
//
//  Created by Дмитрий Билинский on 11/11/24.
//

import Foundation

class NetworkManager: NetworkManagerProtocol {
  func getCoordinate(_ nameCity: String) async throws -> [CoordinateCity] {
    guard let urlCoordinate = URL(string: "https://api.openweathermap.org/geo/1.0/direct?q=\(nameCity)&limit=1&appid=\(ParametersNetworkRequest.keyOpenWeather)") else {fatalError()}
    
    var request =  URLRequest(url: urlCoordinate)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let (data, _) = try await URLSession.shared.data(for: request)
    
    let coordinate = try JSONDecoder().decode([CoordinateCity].self, from: data)
    
    return coordinate
  }
  
  func getWeather(lat: Float, lon: Float) async throws -> WeatherModel {
    guard let urlWeather = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&units=\(ParametersNetworkRequest.units)&lang=\(ParametersNetworkRequest.lang)&exclude=minutely,alerts&appid=\(ParametersNetworkRequest.keyOpenWeather)") else {fatalError()}
    
    var request =  URLRequest(url: urlWeather)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let (data, _) = try await URLSession.shared.data(for: request)
    
    let weatherCity = try JSONDecoder().decode(WeatherModel.self, from: data)
    print ("This is URLSession")
    return weatherCity
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
