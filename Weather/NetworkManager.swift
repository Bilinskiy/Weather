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
  func getCoordinate(_ nameCity: String, completion: @escaping () -> Void)
  func getIcon(_ icon: String, completion: @escaping (Result<Data, Error>) -> Void)
  var weatherData: WeatherModel? {get}
}

class NetworkManager: NetworkManagerProtocol {
  
  var weatherData: WeatherModel?
  
  private let keyOpenWeather: String = {
    guard let key = Bundle.main.object(forInfoDictionaryKey: "OpenWeatherKey") as? String else { fatalError("keyOpenWeather not found") }
    return key
  }()
  
  func getCoordinate(_ nameCity: String, completion: @escaping () -> Void) {
    guard let urlCoordinate = URL(string: "https://api.openweathermap.org/geo/1.0/direct?q=\(nameCity)&limit=1&appid=\(keyOpenWeather)") else {return}
    
    var request =  URLRequest(url: urlCoordinate)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
      
      if let response {
        print (response)
      }
      
      if let error {
        print (error)
      }
      
      if let data {
        do {
          let coordinate = try JSONDecoder().decode([CoordinateCity].self, from: data)
          
          self.getWeather(coordinate[0], completion: {
            completion()
          })
          
          print (coordinate)
        } catch {
          print (error)
        }
      }
      
    }
    
    dataTask.resume()
  }
  
  let lang: Language = .ru
  let units: Units = .metric
  
  func getWeather(_ coordinate: CoordinateCity, completion: @escaping () -> Void) {
    
    guard let urlWeather = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(coordinate.lat!)&lon=\(coordinate.lon!)&units=\(units)&lang=\(lang)&exclude=minutely,alerts&appid=\(keyOpenWeather)") else {return}
    
    var request =  URLRequest(url: urlWeather)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
      
      if let response {
        print (response)
      }
      
      if let error {
        print (error)
      }
      
      if let data {
        do {
          let weatherCity = try JSONDecoder().decode(WeatherModel.self, from: data)
          
          self.weatherData = weatherCity
          print (weatherCity)
          
          completion()
        } catch {
          print (error)
        }
      }
      
    }
    
    dataTask.resume()
  }
  
  func getIcon(_ icon: String, completion: @escaping (Result<Data, Error>) -> Void) {
    
    guard let urlIcon = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png") else {return}
    
    var request =  URLRequest(url: urlIcon)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
      
      if let response {
        print (response)
      }
      
      if let error {
        completion(.failure(error))
        print (error)
      }
      
      if let data {
        completion(.success(data))
      }
      
    }
    
    dataTask.resume()
  }
  
  
  
  
}
