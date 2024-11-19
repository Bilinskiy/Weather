//
//  MyTabBarController.swift
//  Weather
//
//  Created by Дмитрий Билинский on 11/19/24.
//

import UIKit

class MyTabBarController: UITabBarController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tabBar.layer.cornerRadius = 25
    tabBar.backgroundColor = .secondarySystemBackground
    setupViewControllersTabBar()
    
  }
  
  func setupViewControllersTabBar() {
    let firstVC = ViewController()
    firstVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
   
    let mapsVC = MapViewController()
    mapsVC.tabBarItem = UITabBarItem(title: "Map", image: UIImage(systemName: "map"), selectedImage: UIImage(systemName: "map.fill"))
    
    viewControllers = [firstVC, mapsVC]
  }
  
  

}
