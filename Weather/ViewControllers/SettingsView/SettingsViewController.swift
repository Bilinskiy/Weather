//
//  SettingsViewController.swift
//  Weather
//
//  Created by Дмитрий Билинский on 12/17/24.
//

import UIKit
import SnapKit

class SettingsViewController: UIViewController {
  
  var dataSettings: [SettingsData] = []
  var modelSettings = [SettingsOptions]()
  
  lazy var tableView: UITableView = {
    var table = UITableView(frame: CGRect(), style: .insetGrouped)
    table.rowHeight = 44
    table.showsVerticalScrollIndicator = false
    table.register(SettingsTableViewCell.self, forCellReuseIdentifier: "SettingsTableViewCell")
    table.dataSource = self
    table.delegate = self

    return table
  }()
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      fetchSettings()
      
      configModelSettings()
      settingsNavigationController()
      
      view.addSubview(tableView)
      
      updateViewConstraints()
    }
  
  
  func settingsNavigationController() {
    navigationItem.title = "Настройки"
    navigationItem.largeTitleDisplayMode = .always
  }
  
  override func updateViewConstraints() {
    super.updateViewConstraints()
    
    tableView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.bottom.equalToSuperview()
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
    }
    
  }
  
  func configModelSettings() {
    
    modelSettings.append(contentsOf: [SettingsOptions(title: "История запросв", icon: UIImage(systemName: "list.clipboard"), handler: {
      self.navigationController?.pushViewController(HistoryViewController(), animated: true)
    }),
                     SettingsOptions(title: "Система измерений", icon: UIImage(systemName: "ruler.fill"), handler: {
      self.navigationController?.pushViewController(MeasurementSystemViewController(dataSettings: self.dataSettings), animated: true)
    }),
                     SettingsOptions(title: "Уведомления", icon: UIImage(systemName: "bell.fill"), handler: {
      self.navigationController?.pushViewController(NotificationViewController(dataSettings: self.dataSettings), animated: true)
    }),
                     SettingsOptions(title: "Формат времени", icon: UIImage(systemName: "clock.fill"), handler: {
      self.navigationController?.pushViewController(TimeFormatViewController(dataSettings: self.dataSettings), animated: true)
    })])
  }
  
  
  func fetchSettings() {
    DataBase.shared.fetchDataSetting(fetchData: { [weak self] result in
      guard let self = self else {return}
      switch result {
      case .success(let data):
        dataSettings = data
      case .failure(_):
        fatalError()
      }
    })
  }
  
}



extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    modelSettings.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as? SettingsTableViewCell  else { return UITableViewCell() }
    
    cell.iconSettings.image = modelSettings[indexPath.row].icon
    cell.labelSettings.text = modelSettings[indexPath.row].title
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    modelSettings[indexPath.row].handler()
  }
  
  
  
}
