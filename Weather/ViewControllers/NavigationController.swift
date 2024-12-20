//
//  NavigationController.swift
//  Weather
//
//  Created by Дмитрий Билинский on 12/17/24.
//

import UIKit

class NavigationController: UINavigationController {

  
    override func viewDidLoad() {
        super.viewDidLoad()

    navigationBar.barStyle = .default
    navigationBar.tintColor = .black
    navigationBar.prefersLargeTitles = true
    navigationBar.isTranslucent = true
      
    }
  
}
