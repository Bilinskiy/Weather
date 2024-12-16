//
//  HistoryViewController.swift
//  Weather
//
//  Created by Дмитрий Билинский on 12/2/24.
//

import UIKit
import SnapKit

class HistoryViewController: UIViewController {

  var dataBase: DataBaseProtocol = DataBase()
  var dataHistory: [HistoryData] = []
  
  let dateFormatter = DateFormatter()

  
  lazy var labelTitle: UILabel = {
    var label = UILabel()
    label.numberOfLines = 2
    label.textAlignment = .center
    label.font = label.font.withSize(40)
    label.textColor = .black
    label.text = "History"
    return label
  }()

  lazy var tableView: UITableView = {
    var table = UITableView(frame: CGRect(), style: .insetGrouped)
    table.rowHeight = 60
    table.showsVerticalScrollIndicator = false
    table.register(HistoryTableViewCell.self, forCellReuseIdentifier: "HistoryTableViewCell")
    table.dataSource = self
    table.delegate = self
    table.allowsSelection = false

    return table
  }()
  
  
  override func viewWillAppear(_ animated: Bool) {
    dataBase.fetchData(fetchData: { result in
      switch result {
      case .success(let data):
        self.dataHistory = data
      case .failure(_):
        fatalError()
      }
    })
    
    tableView.reloadData()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    view.addSubview(labelTitle)
    view.addSubview(tableView)
    
    updateViewConstraints()
  }
  
  
  override func updateViewConstraints() {
    super.updateViewConstraints()
    
    labelTitle.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(16)
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
    }
    
    tableView.snp.makeConstraints { make in
      make.top.equalTo(labelTitle.snp.bottom).inset(-16)
      make.bottom.equalToSuperview()
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
    }
  }
  
  
  
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    dataHistory.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as? HistoryTableViewCell  else {
      return UITableViewCell() }
    
    dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
    let dateStringFormate = dateFormatter.string(from: dataHistory[indexPath.row].dateHistory)
    
    cell.labelHistory.text = "\(dateStringFormate) | \(dataHistory[indexPath.row].weatherData.temp)°"
    cell.labelHistoryCoord.text = "lat: \(dataHistory[indexPath.row].lat) lon: \(dataHistory[indexPath.row].lon)"
    cell.iconMap.isHidden = !dataHistory[indexPath.row].searchMap
    
    return cell
  }
  
  
  
  
  
  
}


