//
//  HomeViewController.swift
//  Weather
//
//  Created by Дмитрий Билинский on 11/11/24.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
  
  let networkManager: NetworkManagerProtocol = NetworkManager()
  
  lazy var textFieldSearchCity: UITextField = {
    var textField = UITextField()
    textField.placeholder = "Name City"
    textField.borderStyle = .roundedRect
    return textField
  }()
  
  lazy var buttonSearchCity: UIButton = {
    var button = UIButton()
    button.backgroundColor = .systemFill
    button.layer.cornerRadius = 5
    button.setImage(UIImage(systemName: "magnifyingglass.circle"), for: .normal)
    button.addTarget(self, action: #selector(tapButtonSearchCity), for: .touchUpInside)
    return button
  }()
  
  lazy var labelWeather: UILabel = {
    var label = UILabel()
    label.numberOfLines = 2
    label.textAlignment = .center
    label.font = label.font.withSize(25)
    label.textColor = .black
    return label
  }()
  
  lazy var iconWeather: UIImageView = {
    var iconWeather =  UIImageView()
    return iconWeather
  }()
  
  lazy var verticalStack: UIStackView = {
    var stack = UIStackView(arrangedSubviews: [labelWeather, iconWeather])
    stack.axis = .vertical
    stack.alignment = .center
    stack.distribution = .fill
    return stack
  }()
  
  lazy var horizontalStack: UIStackView = {
    var stack = UIStackView(arrangedSubviews: [textFieldSearchCity, buttonSearchCity])
    stack.axis = .horizontal
    stack.spacing = 16
    stack.alignment = .center
    stack.distribution = .fill
    return stack
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    addSubview()
    
    updateViewConstraints()
  }
  
  @objc func tapButtonSearchCity() {
    guard let nameCity = textFieldSearchCity.text, !nameCity.isEmpty else {return}
    
    Task {
      guard let coordinate = try await networkManager.getCoordinate(nameCity).first else {return}
      try await networkManager.getWeather(coordinate)
      guard let icon = self.networkManager.weatherData?.current.weather[0].icon, let temp = self.networkManager.weatherData?.current.temp, let description = self.networkManager.weatherData?.current.weather[0].description else {return}
      let imageIcon = try await networkManager.getIcon(icon.description)
      
     
      self.iconWeather.image = UIImage(data: imageIcon)
      self.labelWeather.text = "\(temp) °C \n \(description)"
    }
  }
  
  func addSubview() {
    view.addSubview(horizontalStack)
    view.addSubview(verticalStack)
  }
  
  override func updateViewConstraints() {
    super.updateViewConstraints()
    
    iconWeather.snp.makeConstraints { make in
      make.height.equalTo(150)
      make.width.equalTo(150)
    }
    
    buttonSearchCity.snp.makeConstraints { make in
      make.height.equalTo(textFieldSearchCity.snp.height)
      make.width.equalTo(textFieldSearchCity.snp.height)
    }
    
    horizontalStack.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(16)
      make.centerX.equalToSuperview()
      make.leading.equalToSuperview().inset(16)
      make.trailing.equalToSuperview().inset(16)
    }
    
    verticalStack.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
    
  }
  
  
}

