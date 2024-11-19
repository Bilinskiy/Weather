//
//  TabBarController.swift
//  Weather
//
//  Created by Дмитрий Билинский on 11/19/24.
//

import UIKit

class TabBarController: UITabBarController {
  
  override func viewDidLoad() {
    super.viewDidLoad()

    self.tabBar.addBlur()
    
    setupViewControllersTabBar()
    
  }
  
  func setupViewControllersTabBar() {
    let firstVC = HomeViewController()
    firstVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
   
    let mapsVC = MapViewController()
    mapsVC.tabBarItem = UITabBarItem(title: "Map", image: UIImage(systemName: "map"), selectedImage: UIImage(systemName: "map.fill"))
    
    viewControllers = [firstVC, mapsVC]
  }
  
  

}
