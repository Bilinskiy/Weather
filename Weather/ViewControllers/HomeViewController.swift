//
//  HomeViewController.swift
//  Weather
//
//  Created by Дмитрий Билинский on 11/11/24.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
  
  lazy var networkManager: NetworkManagerProtocol = ParametersNetworkRequest.manager.manager()
  var weatherData: WeatherModel?
  
  lazy var textFieldSearchCity: UITextField = {
    var textField = UITextField()
    textField.placeholder = "Name City"
    textField.borderStyle = .roundedRect
    textField.enablesReturnKeyAutomatically = false
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
  
  lazy var labelWeatherNameCity: UILabel = {
    var label = UILabel()
    label.numberOfLines = 2
    label.textAlignment = .center
    label.font = label.font.withSize(35)
    label.textColor = .black
    return label
  }()
  
  lazy var labelWeatherTemp: UILabel = {
    var label = UILabel()
    label.numberOfLines = 2
    label.textAlignment = .center
    label.font = label.font.withSize(35)
    label.textColor = .black
    return label
  }()
  
  lazy var labelWeatherDescription: UILabel = {
    var label = UILabel()
    label.layer.opacity = 0.7
    label.numberOfLines = 2
    label.textAlignment = .center
    label.font = label.font.withSize(14)
    label.textColor = .black
    return label
  }()
  
  lazy var labelWeatherFeelsLike: UILabel = {
    var label = UILabel()
    label.numberOfLines = 2
    label.textAlignment = .center
    label.font = label.font.withSize(10)
    label.textColor = .black
    return label
  }()
  
  lazy var verticalStackWeather: UIStackView = {
    var stack = UIStackView(arrangedSubviews: [labelWeatherNameCity, labelWeatherTemp, labelWeatherDescription, labelWeatherFeelsLike])
    stack.axis = .vertical
    stack.alignment = .center
    stack.distribution = .fill
    return stack
  }()
  
  lazy var horizontalStackSearch: UIStackView = {
    var stack = UIStackView(arrangedSubviews: [textFieldSearchCity, buttonSearchCity])
    stack.axis = .horizontal
    stack.spacing = 16
    stack.alignment = .center
    stack.distribution = .fill
    return stack
  }()
  
  lazy var tableView: UITableView = {
    var table = UITableView(frame: CGRect(), style: .plain)
    table.separatorStyle = .none
    table.showsVerticalScrollIndicator = false
    table.register(HoursWeatherTableViewCell.self, forCellReuseIdentifier: "HoursWeatherTableViewCell")
    table.register(DailyWeatherTableViewCell.self, forCellReuseIdentifier: "DailyWeatherTableViewCell")
    table.dataSource = self
    table.delegate = self
    table.isHidden = true
    table.allowsSelection = false
    table.backgroundColor = .clear
    return table
  }()
    
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .orange
    addSubview()
    
    updateViewConstraints()
  }
  
  @objc func tapButtonSearchCity() {
    guard let nameCity = textFieldSearchCity.text, !nameCity.isEmpty else {return}
    
    Task {
      do {
        guard let coordinate = try await networkManager.getCoordinate(nameCity).first, let lat = coordinate.lat, let lon = coordinate.lon else {return}
        
        weatherData = try await networkManager.getWeather(lat: lat, lon: lon)
        
        guard let temp = self.weatherData?.current.temp, let description = self.weatherData?.current.weather[0].description, let feelsLike = self.weatherData?.current.feelsLike else {return}
        
        self.labelWeatherNameCity.text = coordinate.name?.description
        self.labelWeatherTemp.text = "\(temp.roundingNumber())°"
        self.labelWeatherDescription.text = description.description
        self.labelWeatherFeelsLike.text = "ощущается как \(feelsLike)°"
        
        tableView.reloadData()
        tableView.isHidden = false
      } catch {
        fatalError()
      }
    }
  }
  
  func addSubview() {
    view.addSubview(verticalStackWeather)
    view.addSubview(horizontalStackSearch)
    view.addSubview(tableView)
  }
  
  override func updateViewConstraints() {
    super.updateViewConstraints()

    buttonSearchCity.snp.makeConstraints { make in
      make.height.equalTo(textFieldSearchCity.snp.height)
      make.width.equalTo(textFieldSearchCity.snp.height)
    }
    
    horizontalStackSearch.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(16)
      make.centerX.equalToSuperview()
      make.leading.equalToSuperview().inset(16)
      make.trailing.equalToSuperview().inset(16)
    }
    
    verticalStackWeather.snp.makeConstraints { make in
      make.top.equalTo(horizontalStackSearch.snp.bottom).inset(-8)
      make.centerX.equalToSuperview()
    }
    
    tableView.snp.makeConstraints { make in
      make.leading.equalToSuperview().inset(8)
      make.trailing.equalToSuperview().inset(8)
      make.bottom.equalToSuperview()
      make.top.equalTo(verticalStackWeather.snp.bottom).inset(-16)
      
    }
    
  }
  
  
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
  
  func numberOfSections(in tableView: UITableView) -> Int { 2 }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    section == 0 ? "ПОЧАСАВОЙ ПРОГНОЗ" : "ЕЖЕДНЕВНЫЙ ПРОГНОЗ"
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    section == 0 ? 1 : self.weatherData?.daily.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "HoursWeatherTableViewCell", for: indexPath) as? HoursWeatherTableViewCell  else {
        return UITableViewCell() }
      
      cell.layer.backgroundColor = UIColor.clear.cgColor
      cell.backgroundColor = .clear
      
      cell.hourlyWeather = weatherData?.hourly
      cell.collectionView.reloadData()
      
      return cell
    } else {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "DailyWeatherTableViewCell", for: indexPath) as? DailyWeatherTableViewCell, let tempMax = weatherData?.daily[indexPath.row].temp.max, let tempMin = weatherData?.daily[indexPath.row].temp.min else {
        return UITableViewCell() }
      
      
      if let icon = weatherData?.daily[indexPath.row].weather.first?.icon {
        Task {
          let imageIcon = try await networkManager.getIcon(icon)
          cell.iconWeather.image = UIImage(data: imageIcon)
        }
      }
      
      cell.labelWeatherTime.text = indexPath.row == 0 ? "Сейчас" : weatherData?.daily[indexPath.row].dt?.dateFormatter(dateFormat: .dayWeek)
      cell.labelWeatherTempMax.text = "\(tempMax.roundingNumber())°"
      cell.labelWeatherTempMin.text = "\(tempMin.roundingNumber())°"
      
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    indexPath.section == 0 ? 100 : 44
  }
  
  
}

