//
//  MapViewController.swift
//  Weather
//
//  Created by Дмитрий Билинский on 11/19/24.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController, GMSMapViewDelegate {
  
  private let keyGoogleMaps: String = {
    guard let key = Bundle.main.object(forInfoDictionaryKey: "GoogleMapsKey") as? String else { fatalError("GoogleMapsKey not found") }
    return key
  }()
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    GMSServices.provideAPIKey(keyGoogleMaps)
    
    addMaps()
    
    
    
  }
  
  func addMaps() {
    let options = GMSMapViewOptions()
    options.camera = GMSCameraPosition(latitude: 54.029, longitude: 27.597, zoom: 6.0)
    options.frame = self.view.bounds;
    let mapView = GMSMapView(options:options)
    mapView.delegate = self
    self.view = mapView
  }
  
  func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
    print (coordinate.latitude, coordinate.longitude)
  }
  
}
