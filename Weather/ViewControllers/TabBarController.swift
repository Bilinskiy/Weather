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

    tabBar.addBlur(.light)
    
    setupViewControllersTabBar()
  }
  
  func setupViewControllersTabBar() {
    UITabBar.appearance().tintColor = .myColorGray
    UITabBar.appearance().unselectedItemTintColor = .myColorWhite
    
    let firstVC = HomeViewController()
    firstVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
   
    let mapsVC = MapViewController()
    mapsVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "map"), selectedImage: UIImage(systemName: "map.fill"))
    
    let historyVC = HistoryViewController()
    historyVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "clock"), selectedImage: UIImage(systemName: "clock.fill"))
    
    viewControllers = [mapsVC, firstVC, historyVC]
    self.selectedIndex = 1
  }
  
  

}
