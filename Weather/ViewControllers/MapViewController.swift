//
//  MapViewController.swift
//  Weather
//
//  Created by Дмитрий Билинский on 11/19/24.
//

import UIKit
import SnapKit
import GoogleMaps

class MapViewController: UIViewController {
 
  let networkManager: NetworkManagerProtocol = ParametersNetworkRequest.manager.manager()
  var currentWeather: Current?
  var dataBase: DataBaseProtocol = DataBase()

  private let keyGoogleMaps: String = {
    guard let key = Bundle.main.object(forInfoDictionaryKey: "GoogleMapsKey") as? String else { fatalError("GoogleMapsKey not found") }
    return key
  }()
  
  lazy var labelWeather: UILabel = {
    var label = UILabel()
    label.textAlignment = .center
    label.font = UIFont.boldSystemFont(ofSize: 18)
    label.textColor = .black
    return label
  }()
  
  lazy var iconWeather: UIImageView = {
    var iconWeather =  UIImageView()
    iconWeather.layer.shadowColor = UIColor.gray.cgColor
    iconWeather.layer.shadowRadius = 2.0
    iconWeather.layer.shadowOpacity = 0.7
    iconWeather.layer.shadowOffset = CGSize(width: 3, height: 3)
    iconWeather.layer.masksToBounds = false
    return iconWeather
  }()
  
  lazy var markerViewBase: UIView = {
    var view = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 72))
    view.backgroundColor = .clear
    return view
  }()
  
  lazy var markerView: UIView = {
    var view = UIView()
    view.layer.cornerRadius = 20
    view.layer.masksToBounds = true
    view.layer.borderColor = UIColor.myColorGray.cgColor
    view.layer.borderWidth = 3
    view.backgroundColor = .myColorWhite
    view.addSubview(labelWeather)
    view.addSubview(iconWeather)
    return view
  }()
  
  lazy var markerViewCircle: UIView = {
    var view = UIView()
    view.layer.cornerRadius = 5
    view.backgroundColor = .myColorGray
    return view
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    GMSServices.provideAPIKey(keyGoogleMaps)
  
    markerViewBase.addSubview(markerViewCircle)
    markerViewBase.addSubview(markerView)
   
    addMaps()
    
    updateViewConstraints()
  }
  
  override func updateViewConstraints() {
    super.updateViewConstraints()
    
    markerViewCircle.snp.makeConstraints { make in
      make.height.equalTo(10)
      make.width.equalTo(10)
      make.centerX.equalToSuperview()
      make.bottom.equalToSuperview()
    }
    
    markerView.snp.makeConstraints { make in
      make.height.equalTo(60)
      make.width.equalTo(60)
      make.centerX.equalToSuperview()
      make.bottom.equalTo( markerViewCircle.snp.top).inset(-2)
    }
    
    labelWeather.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().inset(8)
    }
    
    iconWeather.snp.makeConstraints { make in
      make.height.equalTo(45)
      make.width.equalTo(45)
      make.centerX.equalToSuperview()
      make.top.equalTo(labelWeather.snp.bottom).inset(12)
    }
  }
  
  func addMaps() {
    let options = GMSMapViewOptions()
    options.camera = GMSCameraPosition(latitude: 54.029, longitude: 27.597, zoom: 6.0)
    options.frame = self.view.bounds;
    let mapView = GMSMapView(options:options)
    mapView.delegate = self
    self.view = mapView
  }
  
}

extension MapViewController: GMSMapViewDelegate { 
  func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
    mapView.clear()
    
    Task {      
      currentWeather = try await networkManager.getWeather(lat: Float(coordinate.latitude), lon: Float(coordinate.longitude)).current
      
      guard let icon = self.currentWeather?.weather.first?.icon, let temp = self.currentWeather?.temp, let feelsLike = self.currentWeather?.feelsLike, let pressure = self.currentWeather?.pressure, let humidity = self.currentWeather?.humidity else {return}
      
      let imageIcon = try await networkManager.getIcon(icon.description)
      
      
      self.iconWeather.image = UIImage(data: imageIcon)
      self.labelWeather.text = "\(temp.roundingNumber())°"
      
      let position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
     
      let marker = GMSMarker(position: position)
      marker.iconView = markerViewBase
      marker.map = mapView
      
      mapView.animate(with: GMSCameraUpdate.setTarget(position))
      
      let weatherData = WeatherData(temp: temp.roundingNumber(), feelsLike: feelsLike, pressure: pressure, humidity: humidity)
      let dataHistory = HistoryData(dateHistory: Date(), lat: Float(coordinate.latitude), lon: Float(coordinate.longitude), weatherData: weatherData)
      
      dataBase.saveData(date: dataHistory)
   
    }
  }
  
}
