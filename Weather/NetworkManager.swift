//
//  NetworkManager.swift
//  Weather
//
//  Created by Дмитрий Билинский on 11/11/24.
//

import Foundation

protocol NetworkManagerProtocol {
  func getWeather(_ nameCity: String)
}

class NetworkManager: NetworkManagerProtocol {
  
  private let keyOpenWeather: String = {
    guard let key = Bundle.main.object(
      forInfoDictionaryKey: "OpenWeatherKey"
    ) as? String else {
      fatalError("keyOpenWeather not found")
    }
    return key
  }()
  
  
  func getWeather(_ nameCity: String) {
    guard let urlWeather = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(nameCity)&appid=\(keyOpenWeather)&units=metric&lang=ru") else {return}
   
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
          print (weatherCity)
        } catch {
          print (error)
        }
      }
      
    }
    
    dataTask.resume()
    
  }
  
  
  
  
  
  
  
}
