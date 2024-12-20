//
//  NotificationViewController.swift
//  Weather
//
//  Created by Дмитрий Билинский on 12/18/24.
//

import UIKit
import SnapKit

class NotificationViewController: UIViewController {
  
 // var dataBase: DataBaseProtocol = DataBase()
  var dataSettings: [SettingsData] = []
  
  init(dataSettings: [SettingsData]) {
    self.dataSettings = dataSettings
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  lazy var switchControl200: UISwitch = {
    var switchButton = UISwitch()
    switchButton.addTarget(self, action: #selector(isSwitch200), for: .valueChanged)
    return switchButton
  }()
  
  lazy var switchControl500: UISwitch = {
    var switchButton = UISwitch()
    switchButton.addTarget(self, action: #selector(isSwitch500), for: .valueChanged)
    return switchButton
  }()
  
  lazy var switchControl600: UISwitch = {
    var switchButton = UISwitch()
    switchButton.addTarget(self, action: #selector(isSwitch600), for: .valueChanged)
    return switchButton
  }()
  
  lazy var label200: UILabel = {
    var label = UILabel()
    label.text = "Уведомление о грозе"
    label.textAlignment = .left
    label.textColor = .black
    return label
  }()
  
  lazy var label500: UILabel = {
    var label = UILabel()
    label.text = "Уведомление о дожде"
    label.textAlignment = .left
    label.textColor = .black
    return label
  }()
  
  lazy var label600: UILabel = {
    var label = UILabel()
    label.text = "Уведомление о снеге"
    label.textAlignment = .left
    label.textColor = .black
    return label
  }()
  
  lazy var horizontalStack200: UIStackView = {
    var stack = UIStackView(arrangedSubviews: [label200, switchControl200])
    stack.axis = .horizontal
    stack.spacing = 16
    stack.alignment = .center
    stack.distribution = .equalSpacing
    return stack
  }()
  
  lazy var horizontalStack500: UIStackView = {
    var stack = UIStackView(arrangedSubviews: [label500, switchControl500])
    stack.axis = .horizontal
    stack.spacing = 16
    stack.alignment = .center
    stack.distribution = .equalSpacing
    return stack
  }()
  
  lazy var horizontalStack600: UIStackView = {
    var stack = UIStackView(arrangedSubviews: [label600, switchControl600])
    stack.axis = .horizontal
    stack.spacing = 16
    stack.alignment = .center
    stack.distribution = .equalSpacing
    return stack
  }()
  
  lazy var verticalStack: UIStackView = {
    var stack = UIStackView(arrangedSubviews: [horizontalStack200, horizontalStack500, horizontalStack600])
    stack.spacing = 24
    stack.axis = .vertical
    stack.alignment = .trailing
    stack.distribution = .fill
    return stack
  }()
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    guard let notification = dataSettings.first?.notification else {return}
    
    switchControl200.isOn = notification.notification200
    switchControl500.isOn = notification.notification500
    switchControl600.isOn = notification.notification600
  }
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      view.addSubview(verticalStack)
   
      
      view.backgroundColor = .white
      
      navigationItem.title = "уведомления"
      navigationItem.largeTitleDisplayMode = .never
      updateViewConstraints()
    }
  
  
  @objc func isSwitch200() {
    dataSettings.first?.notification.notification200 = switchControl200.isOn

    do {
      try  DataBase.shared.context?.save()
    } catch {
      fatalError()
    }
  }
  
  @objc func isSwitch500() {
    dataSettings.first?.notification.notification500 = switchControl500.isOn
 
    do {
      try  DataBase.shared.context?.save()
    } catch {
      fatalError()
    }
  }
  
  @objc func isSwitch600() {
    dataSettings.first?.notification.notification600 = switchControl600.isOn
 
    do {
      try  DataBase.shared.context?.save()
    } catch {
      fatalError()
    }
  }
    
  override func updateViewConstraints() {
    super.updateViewConstraints()
    
    verticalStack.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
    
  }

  
  
  
}
