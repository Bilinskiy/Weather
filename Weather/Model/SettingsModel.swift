//
//  SettingsModel.swift
//  Weather
//
//  Created by Дмитрий Билинский on 12/17/24.
//

import Foundation
import UIKit

struct SettingsOptions {
  let title: String
  let icon: UIImage?
  let handler: (() -> Void)
}
