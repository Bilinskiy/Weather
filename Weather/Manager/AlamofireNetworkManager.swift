//
//  AlamofireNetworkManager.swift
//  Weather
//
//  Created by Дмитрий Билинский on 11/29/24.
//

import Foundation
import Alamofire

class AlamofireNetworkManager: NetworkManagerProtocol {
  func getCoordinate(_ nameCity: String) async throws -> [CoordinateCity] {
    let params = addParams(queryItems: ["q": nameCity, "limit": "1"])
    let coordinateCity = try await AF.request(ParametersNetworkRequest.coordinateURL, method: .get, parameters: params).serializingDecodable([CoordinateCity].self).value
    return coordinateCity
  }
  
  func getWeather(lat: Float, lon: Float) async throws -> WeatherModel {
    let params = addParams(queryItems: ["lat": "\(lat)", "lon": "\(lon)", "units": "\(ParametersNetworkRequest.units)", "lang": "\(ParametersNetworkRequest.lang)", "exclude": "minutely,alerts"])
    let weatherData = try await AF.request(ParametersNetworkRequest.weatherURL, method: .get, parameters: params).serializingDecodable(WeatherModel.self).value
    print ("This is Alamofire")
    return weatherData
  }
  
  func getIcon(_ icon: String) async throws -> Data {
    let url = "\(ParametersNetworkRequest.iconURL)\(icon)@2x.png"
    let dataImage = try await AF.download(url).serializingData().value
    return dataImage
  }
  
  private func addParams(queryItems: [String: String]) -> [String: String] {
    var params: [String: String] = [:]
    params = queryItems
    params["appid"] = "\(ParametersNetworkRequest.keyOpenWeather)"
    return params
  }
  
  
  
  
  
  
  
}
