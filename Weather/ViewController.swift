//
//  ViewController.swift
//  Weather
//
//  Created by Дмитрий Билинский on 11/11/24.
//

import UIKit

class ViewController: UIViewController {

  let networkManager: NetworkManagerProtocol = NetworkManager()
  
  let nameCity = "Brest"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    networkManager.getWeather(nameCity)
    
    
  }


}

