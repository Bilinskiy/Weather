//
//  DailyWeatherTableViewCell.swift
//  Weather
//
//  Created by Дмитрий Билинский on 11/26/24.
//

import UIKit
import SnapKit

class DailyWeatherTableViewCell: UITableViewCell {
  
  lazy var labelWeatherTime: UILabel = {
    var label = UILabel()
    label.textAlignment = .center
    label.font = label.font.withSize(15)
    label.textColor = .black
    return label
  }()
  
  lazy var labelWeatherTempMin: UILabel = {
    var label = UILabel()
    label.textAlignment = .center
    label.font = label.font.withSize(15)
    label.textColor = .black
    return label
  }()
  
  lazy var separateView: UIView = {
    var view = UIView()
    view.layer.opacity = 0.7
    view.backgroundColor = .black
    return view
  }()
  
  lazy var labelWeatherTempMax: UILabel = {
    var label = UILabel()
    label.textAlignment = .center
    label.font = label.font.withSize(15)
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
  
  lazy var horizontalStack: UIStackView = {
    var stack = UIStackView(arrangedSubviews: [labelWeatherTime, iconWeather, labelWeatherTempMin, separateView, labelWeatherTempMax])
    stack.axis = .horizontal
    stack.alignment = .center
    stack.distribution = .equalCentering
    stack.spacing = 0
    return stack
  }()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    backgroundColor = .clear
    contentView.addSubview(horizontalStack)
    
    updateConstraints()
  }
  
  override func updateConstraints() {
    super.updateConstraints()
    
    separateView.snp.makeConstraints { make in
      make.height.equalTo(2)
      make.width.equalTo(70)
    }
    iconWeather.snp.makeConstraints { make in
      make.height.equalTo(40)
      make.width.equalTo(40)
    }
    
    horizontalStack.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.bottom.equalToSuperview()
      make.leading.equalToSuperview().inset(16)
      make.trailing.equalToSuperview().inset(16)
    }
    
    
  }
}
