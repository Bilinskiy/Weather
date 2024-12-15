//
//  Notification.swift
//  Weather
//
//  Created by Дмитрий Билинский on 12/3/24.
//

import Foundation
import UIKit

protocol NotificationProtocol {
  func notification(data: [Hourly])
}

class Notification: NotificationProtocol {
  let notificationCenter = UNUserNotificationCenter.current()

  func addNotification(data: Hourly) {
    notificationCenter.requestAuthorization(options: [.alert, .sound]) { isAuthorized, error in
      if isAuthorized {
        
        let content = UNMutableNotificationContent()
        
        guard let dt = data.dt, let description = data.weather.first?.description else {return}
        
        content.body = description
        
        let dateTimeInterval = Date(timeIntervalSince1970: TimeInterval(dt))
        
        let calendar = Calendar.current
        
        guard let date = calendar.date(byAdding: .minute, value: -30, to: dateTimeInterval) else {return}
        
        let components = calendar.dateComponents([.day, .hour, .minute], from: date)
     
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let identifier = "identifier\(data)"
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        self.notificationCenter.add(request)
        print (request)
      }
    }
  }
    
    func notification(data: [Hourly]) {
      notificationCenter.removeAllPendingNotificationRequests()
      
      let filter200 = data.filter({(200..<300).contains($0.weather.first?.id ?? 0)})
      let filter500 = data.filter({(500..<600).contains($0.weather.first?.id ?? 0)})
      let filter600 = data.filter({(600..<700).contains($0.weather.first?.id ?? 0)})

      if !filter200.isEmpty { sortNotification(data: filter200) }
      if !filter500.isEmpty { sortNotification(data: filter500) }
      if !filter600.isEmpty { sortNotification(data: filter600) }
    }
  
  func sortNotification(data: [Hourly]) {
    for i in 0 ..< data.count {
      if  i != 0 {
        if data[i].dt! - data[i-1].dt! != 3600.0  { addNotification(data: data[i]) }
      } else {
        addNotification(data: data[i])
      }
    }
  }
  

}
