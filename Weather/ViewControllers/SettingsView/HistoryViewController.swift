//
//  HistoryViewController.swift
//  Weather
//
//  Created by Дмитрий Билинский on 12/2/24.
//

import UIKit
import SnapKit

class HistoryViewController: UIViewController {

  var dataHistory: [HistoryData] = []
  
  let dateFormatter = DateFormatter()

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
    DataBase.shared.fetchData(fetchData: { [weak self] result in
      guard let self = self else {return}
      switch result {
      case .success(let data):
        self.dataHistory = data.sorted(by: {$0.dateHistory > $1.dateHistory})
      case .failure(_):
        fatalError()
      }
    })
    
    tableView.reloadData()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "История"
    navigationItem.largeTitleDisplayMode = .never
    view.addSubview(tableView)
    
    updateViewConstraints()
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
   
    cell.labelHistoryCoord.text = String(format: "HistoryViewController.labelHistoryCoord".localizationString(), dataHistory[indexPath.row].lat, dataHistory[indexPath.row].lon)
    cell.iconMap.isHidden = !dataHistory[indexPath.row].searchMap
    
    return cell
  }
  
  
  
  
  
  
}


