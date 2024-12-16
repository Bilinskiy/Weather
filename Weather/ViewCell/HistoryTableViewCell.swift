//
//  HistoryTableViewCell.swift
//  Weather
//
//  Created by Дмитрий Билинский on 12/2/24.
//

import UIKit
import SnapKit

class HistoryTableViewCell: UITableViewCell {

  lazy var labelHistory: UILabel = {
    var label = UILabel()
    label.textAlignment = .center
    label.textColor = .black
    return label
  }()
  
  lazy var labelHistoryCoord: UILabel = {
    var label = UILabel()
    label.textAlignment = .center
    label.textColor = .black
    return label
  }()
  
  lazy var stackVertical: UIStackView = {
    var stack = UIStackView(arrangedSubviews: [labelHistory, labelHistoryCoord])
    stack.axis = .vertical
    stack.spacing = 4
    stack.distribution = .fillEqually
    stack.alignment = .leading
    return stack
  }()
  
  lazy var iconMap: UIImageView = {
    var icon =  UIImageView(image: UIImage(systemName: "map"))
    return icon
  }()
  
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      contentView.addSubview(stackVertical)
      contentView.addSubview(iconMap)
      updateConstraints()
    }
  
  override func updateConstraints() {
    super.updateConstraints()
    
    iconMap.snp.makeConstraints { make in
      make.height.equalTo(20)
      make.width.equalTo(20)
      make.top.equalToSuperview().inset(4)
      make.trailing.equalToSuperview().inset(4)
    }
    
    stackVertical.snp.makeConstraints { make in
      make.leading.equalToSuperview().inset(16)
      make.centerY.equalToSuperview()
    }
    
  }

}
