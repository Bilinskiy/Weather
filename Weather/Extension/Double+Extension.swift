//
//  Double+Extension.swift
//  Weather
//
//  Created by Дмитрий Билинский on 11/28/24.
//

import Foundation

enum DateFormat: String {
  case dayWeek = "E"
  case hour = "HH"
  case dateTime = "MM-dd-yyyy HH:mm"
}

extension Double {
  func dateFormatter(dateFormat: DateFormat) -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(self))
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat.rawValue
    let dateStringFormate = dateFormatter.string(from: date)
    return dateStringFormate
  }
  
}
