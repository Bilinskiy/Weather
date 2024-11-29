//
//  Float+Extension.swift
//  Weather
//
//  Created by Дмитрий Билинский on 11/28/24.
//

import Foundation


extension Float {
  
  func roundingNumber() -> Int {
    let fractionalPart = fabsf(self) - Float(Int(fabsf(self)))
    
    if self < 0 {
      return fractionalPart >= 0.5 ? Int(self - (1 - fractionalPart)) : Int(self)
    } else {
      return fractionalPart >= 0.5 ? Int(self + (1 - fractionalPart)) : Int(self)
    }
  }
  
}
