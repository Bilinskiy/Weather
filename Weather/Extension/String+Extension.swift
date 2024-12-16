//
//  String+Extension.swift
//  Weather
//
//  Created by Дмитрий Билинский on 12/16/24.
//

import Foundation

extension String {
  func localizationString() -> String {
    return NSLocalizedString(self, comment: "")
  }
}
