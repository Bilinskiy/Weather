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
  var searchMap: Bool
  
  init(dateHistory: Date, lat: Float, lon: Float, weatherData: WeatherData, searchMap: Bool) {
    self.dateHistory = dateHistory
    self.lat = lat
    self.lon = lon
    self.weatherData = weatherData
    self.searchMap = searchMap
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

@Model
final class SettingsData {
  var measurement: Units
  var notification: CategoryNotification
  var formatDate: DateFormat
  
  init(measurement: Units, notification: CategoryNotification, formatDate: DateFormat) {
    self.measurement = measurement
    self.notification = notification
    self.formatDate = formatDate
  }
}

struct CategoryNotification: Codable {
    var notification200: Bool
    var notification500: Bool
    var notification600: Bool
}

class DataBase {
  
  static let shared = DataBase()

  var container: ModelContainer?
  var context: ModelContext?
  
private init() {
    do {
      container = try ModelContainer(for: HistoryData.self, SettingsData.self)
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
  
// Работа с историей запросов для отслеживание изменений в базе данных
  
//  func findTransactions(token: DefaultHistoryToken?) -> [DefaultHistoryTransaction] {
//    var historyDescriptor = HistoryDescriptor<DefaultHistoryTransaction>()
//    
//    if let token {
//      historyDescriptor.predicate = #Predicate { transaction in
//        transaction.token > token
//      }
//    }
//    
//    var transactions: [DefaultHistoryTransaction] = []
//    do {
//      if let context = context {
//        transactions = try context.fetchHistory(historyDescriptor)
//      }
//    } catch {
//      fatalError()
//    }
//    
//    return transactions
//  }
  
//  func find(transactions: [DefaultHistoryTransaction]) -> (Set<SettingsData>, DefaultHistoryToken?) {
//   
//    
//    var resultFind: Set<SettingsData> = []
//    
//    for transactions in transactions {
//      for change in transactions.changes {
//        let modelID = change.changedPersistentIdentifier
//        let fetchDescriptor = FetchDescriptor<SettingsData>(predicate: #Predicate { trip in
//          trip.persistentModelID == modelID
//        })
//        let fetchResult = try? context?.fetch(fetchDescriptor)
//        guard let matc = fetchResult?.first else {
//          continue
//        }
//        
//        switch change {
//          
//        case .insert(_):
//          resultFind.insert(matc)
//        case .update(_):
//          resultFind.update(with: matc)
//        case .delete(_):
//          resultFind.remove(matc)
//        default:
//          break
//        }
//        
//        
//      }
//      
//    }
//    
//    return (resultFind, transactions.last?.token)
//  }
  
  
  func fetchData(fetchData: @escaping (Result<[HistoryData], Error>) -> Void) {
    let descriptor = FetchDescriptor<HistoryData>()
    
    if let context {
      
      do {
        let historyData = try context.fetch(descriptor)
        fetchData(.success(historyData))
      } catch {
        fetchData(.failure(error))
      }
      
    }
  }
  
  func fetchDataSetting(fetchData: @escaping (Result<[SettingsData], Error>) -> Void) {
    let descriptor = FetchDescriptor<SettingsData>()
    
    if let context {
      
      do {
        let settingsData = try context.fetch(descriptor)
        fetchData(.success(settingsData))
      } catch {
        fetchData(.failure(error))
      }
      
    }
  }
  
  
  
  
  
}
