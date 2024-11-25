//
//  UIView+Extension.swift
//  Weather
//
//  Created by Дмитрий Билинский on 11/19/24.
//

import Foundation
import UIKit

extension UIView {
  
  func addBlur(_ style: UIBlurEffect.Style) {
    let blur = UIBlurEffect(style: style)
    let blurView = UIVisualEffectView(effect: blur)
    blurView.frame = self.bounds
    blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    self.addSubview(blurView)
  }
  
  
}
