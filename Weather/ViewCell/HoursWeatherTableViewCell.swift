//
//  HoursWeatherTableViewCell.swift
//  Weather
//
//  Created by Дмитрий Билинский on 11/25/24.
//

import UIKit
import SnapKit

class HoursWeatherTableViewCell: UITableViewCell {
  
  let networkManager: NetworkManagerProtocol = ParametersNetworkRequest.manager.manager()
  var hourlyWeather: [Hourly]?
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 8
    layout.minimumInteritemSpacing = 8
    var collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collection.register(HoursWeatherCollectionViewCell.self, forCellWithReuseIdentifier: "HoursWeatherCollectionViewCell")
    collection.showsHorizontalScrollIndicator = false
    collection.dataSource = self
    collection.delegate = self
    collection.backgroundColor = .clear
    return collection
  }()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    contentView.addSubview(collectionView)
    
    updateConstraints()
  }
  
  
  override func updateConstraints() {
    super.updateConstraints()
    
    collectionView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.bottom.equalToSuperview()
      make.trailing.equalToSuperview()
      make.leading.equalToSuperview()
    }
    
  }
}

extension HoursWeatherTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    self.hourlyWeather?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HoursWeatherCollectionViewCell", for: indexPath) as? HoursWeatherCollectionViewCell, let temp = self.hourlyWeather?[indexPath.row].temp else {return UICollectionViewCell()}
    
    if let icon = self.hourlyWeather?[indexPath.row].weather.first?.icon {
      Task {
        let imageIcon = try await networkManager.getIcon(icon)
        cell.iconWeather.image = UIImage(data: imageIcon)
      }
    }
    
    cell.labelWeatherTime.text = indexPath.row == 0 ? "Сейчас" : self.hourlyWeather?[indexPath.row].dt?.dateFormatter(dateFormat: .hour)
    cell.labelWeatherTemp.text = "\(temp.roundingNumber())°"
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    CGSize(width: 60, height: 100)
  }
  
  
  
}

