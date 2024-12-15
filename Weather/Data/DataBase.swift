//
//  DataBase.swift
//  Weather
//
//  Created by Дмитрий Билинский on 12/2/24.
//

import Foundation
import SwiftData

@Model
final class HistoryData {
  var dateHistory: Date
  var lat: Float
  var lon: Float
  var weatherData: WeatherData
  
  init(dateHistory: Date, lat: Float, lon: Float, weatherData: WeatherData) {
    self.dateHistory = dateHistory
    self.lat = lat
    self.lon = lon
    self.weatherData = weatherData
  }
}

@Model
final class WeatherData {
  var temp: Int
  var feelsLike: Float
  var pressure: Int
  var humidity: Int
  
  
  init(temp: Int, feelsLike: Float, pressure: Int, humidity: Int) {
    self.temp = temp
    self.feelsLike = feelsLike
    self.pressure = pressure
    self.humidity = humidity
  }
  
}

protocol DataBaseProtocol {
  func saveData<T>(date: T) where T: PersistentModel
  func fetchData(fetchData: @escaping (Result<[HistoryData], Error>) -> Void)
}

class DataBase: DataBaseProtocol {
  
  var container: ModelContainer?
  var context: ModelContext?
  
  init() {
    do {
      container = try ModelContainer(for: HistoryData.self)
      if let container {
        context = ModelContext(container)
      }
    } catch {
      print("Error initializing database container:", error)
    }
  }
  
  func saveData<T>(date: T) where T: PersistentModel {
    if let context {
      context.insert(date)
      
      do {
        try context.save()
      } catch {
        fatalError()
      }
      
    }
    
  }
  
  func fetchData(fetchData: @escaping (Result<[HistoryData], Error>) -> Void) {
    let descriptor = FetchDescriptor<HistoryData>()
    
    if let context {
      
      do {
        let historyData = try context.fetch(descriptor).sorted(by: {$0.dateHistory > $1.dateHistory})
        fetchData(.success(historyData))
      } catch {
        fetchData(.failure(error))
      }
      
    }
  }

}
