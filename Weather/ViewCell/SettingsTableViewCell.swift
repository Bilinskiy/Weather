//
//  SettingsTableViewCell.swift
//  Weather
//
//  Created by Дмитрий Билинский on 12/17/24.
//

import UIKit
import SnapKit

class SettingsTableViewCell: UITableViewCell {
  
  lazy var labelSettings: UILabel = {
    var label = UILabel()
    label.textAlignment = .center
    label.textColor = .black
    return label
  }()
  
  lazy var iconSettings: UIImageView = {
    var icon =  UIImageView()
    return icon
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    contentView.addSubview(iconSettings)
    contentView.addSubview(labelSettings)

    accessoryType = .disclosureIndicator
    updateConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
  
    }
  
  override func updateConstraints() {
    super.updateConstraints()
    
    iconSettings.snp.makeConstraints { make in
      make.height.equalTo(30)
      make.width.equalTo(30)
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().inset(16)
    }
    
    labelSettings.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalTo(iconSettings.snp.trailing).inset(-16)
    }
    
  }

}
