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
  
  let networkManager: NetworkManagerProtocol = NetworkManager()
  
  private let keyGoogleMaps: String = {
    guard let key = Bundle.main.object(forInfoDictionaryKey: "GoogleMapsKey") as? String else { fatalError("GoogleMapsKey not found") }
    return key
  }()
  
  lazy var labelWeather: UILabel = {
    var label = UILabel()
    label.textAlignment = .center
    label.font = label.font.withSize(12)
    label.textColor = .white
    return label
  }()
  
  lazy var iconWeather: UIImageView = {
    var iconWeather =  UIImageView()
    return iconWeather
  }()
  
  lazy var markerView: UIView = {
    var view = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
    view.layer.cornerRadius = 15
    view.layer.masksToBounds = true
    view.addBlur(.dark)
    return view
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    GMSServices.provideAPIKey(keyGoogleMaps)
    
    markerView.addSubview(labelWeather)
    markerView.addSubview(iconWeather)
    
    addMaps()
    
    updateViewConstraints()
  }
  
  override func updateViewConstraints() {
    super.updateViewConstraints()
    
    labelWeather.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().inset(8)
    }
    
    iconWeather.snp.makeConstraints { make in
      make.height.equalTo(40)
      make.width.equalTo(40)
      make.centerX.equalToSuperview()
      make.top.equalTo(labelWeather.snp.bottom)
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
      let coordinates = CoordinateCity(lat: Float(coordinate.latitude), lon: Float(coordinate.longitude))
      
      try await networkManager.getWeather(coordinates)
      guard let icon = self.networkManager.weatherData?.current.weather.first?.icon, let temp = self.networkManager.weatherData?.current.temp, let description = self.networkManager.weatherData?.current.weather.first?.description else {return}
      let imageIcon = try await networkManager.getIcon(icon.description)
      
      
      self.iconWeather.image = UIImage(data: imageIcon)
      self.labelWeather.text = "\(temp) °C \n \(description)"
      
      let position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
      let marker = GMSMarker(position: position)
      marker.iconView = markerView
      marker.map = mapView
    }
  }
  
}
