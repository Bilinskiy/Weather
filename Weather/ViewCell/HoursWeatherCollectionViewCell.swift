//
//  HoursWeatherCollectionViewCell.swift
//  Weather
//
//  Created by Дмитрий Билинский on 11/26/24.
//

import UIKit
import SnapKit

class HoursWeatherCollectionViewCell: UICollectionViewCell {

  lazy var labelWeatherTime: UILabel = {
    var label = UILabel()
    label.textAlignment = .center
    label.font = label.font.withSize(12)
    label.textColor = .black
    return label
  }()
  
  lazy var labelWeatherTemp: UILabel = {
    var label = UILabel()
    label.textAlignment = .center
    label.font = label.font.withSize(18)
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
  
  lazy var verticalStack: UIStackView = {
    var stack = UIStackView(arrangedSubviews: [labelWeatherTime, iconWeather, labelWeatherTemp])
    stack.axis = .vertical
    stack.alignment = .center
    stack.distribution = .equalSpacing
    stack.spacing = 0
    return stack
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    contentView.backgroundColor = .clear
    contentView.layer.cornerRadius = 25
    contentView.layer.masksToBounds = true
    contentView.layer.borderColor = UIColor.myColorGray.cgColor
    contentView.layer.borderWidth = 3
    
    contentView.addSubview(verticalStack)
    
    updateConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func updateConstraints() {
    super.updateConstraints()
    
    iconWeather.snp.makeConstraints { make in
      make.height.equalTo(50)
      make.width.equalTo(50)
    }
    
    verticalStack.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(8)
      make.bottom.equalToSuperview().inset(8)
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
    }
    
  }
  
  
}

