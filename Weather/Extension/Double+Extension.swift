//
//  Double+Extension.swift
//  Weather
//
//  Created by Дмитрий Билинский on 11/28/24.
//

import Foundation

enum DateFormat: Int, Codable {
  case hour12
  case hour24
  case dayWeek
  case dateTime24
  case dateTime12
  
  var format: String {
    switch self {
    case .dayWeek:
      "E"
    case .hour24:
      "HH"
    case .hour12:
      "hh"
    case .dateTime24:
      "dd-MM-yyyy HH:mm"
    case .dateTime12:
      "dd-MM-yyyy hh:mm"
    }
  }
}

extension Double {
  func dateFormatter(dateFormat: DateFormat) -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(self))
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat.format
    let dateStringFormate = dateFormatter.string(from: date)
    return dateStringFormate
  }
}
