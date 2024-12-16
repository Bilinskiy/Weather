//
//  ParametersNetworkRequest.swift
//  Weather
//
//  Created by Дмитрий Билинский on 11/29/24.
//

import Foundation

protocol NetworkManagerProtocol {
  func getCoordinate(_ nameCity: String) async throws -> [CoordinateCity]
  func getWeather(lat: Float, lon: Float) async throws -> WeatherModel
  func getIcon(_ icon: String) async throws -> Data
}

enum Units {
  case standard
  case metric
  case imperial
}

enum ManagerNetwork {
  case alamofire
  case urlSession
  
  func manager() -> NetworkManagerProtocol {
    switch self {
    case .alamofire:
      return AlamofireNetworkManager()
    case .urlSession:
      return NetworkManager()
    }
  }
  
}

struct ParametersNetworkRequest {
  
  static var manager: ManagerNetwork = .urlSession // выбор сетевого модуля для запросов 
  
  static let keyOpenWeather: String = {
    guard let key = Bundle.main.object(forInfoDictionaryKey: "OpenWeatherKey") as? String else { fatalError("keyOpenWeather not found") } // ключ для OpenWeather зашит в infoplist
    return key
  }()
  
  static let lang: String = {
    guard let lang = Locale.current.language.languageCode else {return "en"}
    return lang.debugDescription
  }() // язык полученных данных
  
  static let units: Units = .metric // система измерений
  
  static var baseURL: String = "https://api.openweathermap.org"
  
  static var coordinateURL: String {
    baseURL.appending("/geo/1.0/direct")
  }
  
  static var weatherURL: String {
    baseURL.appending("/data/2.5/onecall")
  }
  
  static var iconURL: String = "https://openweathermap.org/img/wn/"
  
}
