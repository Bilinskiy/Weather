//
//  HomeViewController.swift
//  Weather
//
//  Created by Дмитрий Билинский on 11/11/24.
//

import UIKit
import SnapKit
import CoreLocation

enum StatusGetWeather: String { //switch для сохранения состояния при повторном входе в приложении
  case location = "location"
  case search = "search"
}

enum LocationButton { //switch для переключения кнопки Локации
  case on
  case off
}

class HomeViewController: UIViewController {
  
  lazy var statusGetWeather: StatusGetWeather = .location
  var locationButton: LocationButton = .off
  
  lazy var networkManager: NetworkManagerProtocol = ParametersNetworkRequest.manager.manager() // в файле ParametersNetworkRequest можно менять через какйто менедж длеать запрос (URLSession or Alamofire)
  
  var weatherData: WeatherModel? // все данные о погоде
  var dataBase: DataBaseProtocol = DataBase() // работа с swift data (локальная базаданных)
  var notification: NotificationProtocol = Notification() // работа с локальными уведомлениями (уведомляют о плохой погоде)
  
  lazy var labelInfo: UILabel = {
    var label = UILabel()
    label.text = "Нет данных"
    label.layer.opacity = 0.5
    label.textAlignment = .center
    label.font = label.font.withSize(35)
    label.textColor = .black
    label.isHidden = false
    return label
  }()
  
  lazy var coreManager: CLLocationManager = {
    let manager = CLLocationManager()
    manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers // точность 3 киллометра
    manager.distanceFilter = 200
    manager.delegate = self
    return manager
  }()
  
  lazy var buttonSearchCity: UIButton = {
    var button = UIButton(type: .contactAdd)
    button.setImage(UIImage(systemName: "magnifyingglass.circle"), for: .normal)
    button.addTarget(self, action: #selector(tapButtonSearchCity), for: .touchUpInside)
    button.tintColor = .black
    return button
  }()
  
  lazy var buttonLocation: UIButton = {
    var button = UIButton(type: .contactAdd)
    button.setImage(UIImage(systemName: "location.circle"), for: .normal)
    button.addTarget(self, action: #selector(tapButtonLocation), for: .touchUpInside)
    button.tintColor = .black
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
    var stack = UIStackView(arrangedSubviews: [buttonSearchCity, buttonLocation])
    stack.axis = .horizontal
    stack.spacing = 16
    stack.alignment = .center
    stack.distribution = .equalSpacing
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
    coreManager.requestWhenInUseAuthorization() // запрос на разрешение получения или НЕ получения геолокации
   
    if let name = UserDefaults.standard.string(forKey: "getWeather") { // загрузка сохраненного состояния приложения, получение погоды через геолокацию или последний запрос по названию города
      statusGetWeather = .search
      taskWeatherData(name)
    } else {
      if UserDefaults.standard.object(forKey: "getLocation") != nil { locationButton = UserDefaults.standard.bool(forKey: "getLocation") ? .off : .on }
      statusGetWeather = .location
      statusGet()
    }
    
    addSubview()
    updateViewConstraints()
  }
  
  func alertSearchCity() {
    let alert = UIAlertController(title: "Поиск", message: "Введите название города", preferredStyle: .alert)
    alert.addTextField()
    alert.textFields?.first?.delegate = self
    alert.textFields?.first?.placeholder = "Названгие города"
    
    let ok = UIAlertAction(title: "Ok", style: .cancel) { _ in
      guard let nameCity = alert.textFields?.first?.text else {return}
      
      self.statusGetWeather = .search
      self.taskWeatherData(nameCity)
    }
    
    let cancel = UIAlertAction(title: "Отмена", style: .destructive)
    
    alert.addAction(ok)
    alert.addAction(cancel)
    
    present(alert, animated: true)
  } // alert для ввода названия города и вывода погоды
  
  func alertSearchCityError() { 
    let alert = UIAlertController(title: "Ошибка", message: "Введены некорректные данные", preferredStyle: .alert)

    let ok = UIAlertAction(title: "Ok", style: .cancel)
    
    alert.addAction(ok)
    present(alert, animated: true)
  } // alert ошибки при вводе неверного названия города
  
  @objc func tapButtonLocation() {
    statusGetWeather = .location
    statusGet()
  }
  
  func statusGet() {
    switch statusGetWeather {
    case .location:
      switch locationButton {
      case .on:
        coreManager.stopUpdatingLocation()
        buttonLocation.setImage(UIImage(systemName: "location.circle"), for: .normal)
        locationButton = .off
        verticalStackWeather.isHidden = true // скрывает данные о погоде с экрана
        tableView.isHidden = true
        labelInfo.isHidden = false
        UserDefaults.standard.set(false, forKey: "getLocation")
      case .off:
        coreManager.startUpdatingLocation()
        buttonLocation.setImage(UIImage(systemName: "location.circle.fill"), for: .normal)
        buttonSearchCity.setImage(UIImage(systemName: "magnifyingglass.circle"), for: .normal)
        locationButton = .on
        UserDefaults.standard.set(true, forKey: "getLocation")
      } // состояние кнопки локации в зависимости нажата она или нет
    case .search:
      coreManager.stopUpdatingLocation()
      buttonSearchCity.setImage(UIImage(systemName: "magnifyingglass.circle.fill"), for: .normal)
      buttonLocation.setImage(UIImage(systemName: "location.circle"), for: .normal)
      locationButton = .off
      UserDefaults.standard.set(false, forKey: "getLocation")
    }
  } // функция для контроля состояния кнопок Локации и Поиска оп нозванию
  
  @objc func tapButtonSearchCity() { alertSearchCity() }
  
  func taskWeatherData(_ nameCity: String) {
    Task {
      do {
        let date = try await networkManager.getCoordinate(nameCity)
        guard !date.isEmpty, let coordinate = date.first, let lat = coordinate.lat, let lon = coordinate.lon else {
          self.alertSearchCityError()
          return} // проверка данных которые приходят по введенному названию города, если данные отсутствуют или не корректны - срабатывает alert ошибка или catch

        weatherData = try await networkManager.getWeather(lat: lat, lon: lon) // получение всех данных о погоде
       
        guard let temp = self.weatherData?.current.temp, let description = self.weatherData?.current.weather.first?.description, let feelsLike = self.weatherData?.current.feelsLike, let pressure = self.weatherData?.current.pressure, let humidity = self.weatherData?.current.humidity else {return}
        
        self.labelWeatherNameCity.text = coordinate.name?.description
        self.labelWeatherTemp.text = "\(temp.roundingNumber())°"
        self.labelWeatherDescription.text = description.description
        self.labelWeatherFeelsLike.text = "ощущается как \(feelsLike)°"
        
        tableView.reloadData()
        verticalStackWeather.isHidden = false
        labelInfo.isHidden = true
        tableView.isHidden = false
        
        let weather = WeatherData(temp: temp.roundingNumber(), feelsLike: feelsLike, pressure: pressure, humidity: humidity)
        let dataHistory = HistoryData(dateHistory: Date(), lat: lat, lon: lon, weatherData: weather)
        dataBase.saveData(date: dataHistory) // сохраняем данные запроса в базу данных Swift Data
        
        guard let dataHourly = weatherData?.hourly else {return}
        notification.notification(data: dataHourly)
        
        if statusGetWeather == .search {
          statusGet()
          UserDefaults.standard.set(nameCity, forKey: "getWeather")
        } // если запрос делается через поиск города то сохраняем название города в UserDefaults что бы загрузить его при повторном запуске приложения

      } catch {
        self.alertSearchCityError()
        self.statusGetWeather = .location
      }
    }
  } // сетевой запрос данных в Task
  
  func addSubview() {
    view.addSubview(labelInfo)
    view.addSubview(verticalStackWeather)
    view.addSubview(horizontalStackSearch)
    view.addSubview(tableView)
  } // добавление всех View
  
  override func updateViewConstraints() {
    super.updateViewConstraints()
    
    labelInfo.snp.makeConstraints { make in
      make.center.equalToSuperview()
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

extension HomeViewController: CLLocationManagerDelegate {
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
      buttonLocation.isEnabled = true
    } else {
      buttonLocation.isEnabled = false
      verticalStackWeather.isHidden = true
      labelInfo.isHidden = false
      tableView.isHidden = true
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let coordinate = locations.first else {return}

    CLGeocoder().reverseGeocodeLocation(coordinate, completionHandler: { response, error in
      if (error != nil) {
        fatalError()
      } else {
        guard let address = response?.first?.locality else {return}
        UserDefaults.standard.set(nil, forKey: "getWeather")
        UserDefaults.standard.set(true, forKey: "getLocation")
        self.taskWeatherData(address)
      }
    })
    
 
  }
}

extension HomeViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let setLetters = CharacterSet.letters // сет букв
    
    return string.rangeOfCharacter(from: setLetters) != nil // разрешает ввод только букв
  }
}
