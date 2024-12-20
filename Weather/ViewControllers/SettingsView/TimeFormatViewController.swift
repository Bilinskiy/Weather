//
//  TimeFormatViewController.swift
//  Weather
//
//  Created by Дмитрий Билинский on 12/18/24.
//

import UIKit
import SnapKit

class TimeFormatViewController: UIViewController {
  
//  var dataBase: DataBaseProtocol = DataBase()
  var dataSettings: [SettingsData]
  
  init(dataSettings: [SettingsData]) {
    self.dataSettings = dataSettings
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  lazy var segmentControl: UISegmentedControl = {
    var segment = UISegmentedControl()
    segment.insertSegment(withTitle: "12", at: 0, animated: true)
    segment.insertSegment(withTitle: "24", at: 1, animated: true)
    segment.addTarget(self, action: #selector(isSegment), for: .valueChanged)
    return segment
  }()
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    guard let formatDate = dataSettings.first?.formatDate else {return}
    segmentControl.selectedSegmentIndex = formatDate.rawValue
  }
  

    override func viewDidLoad() {
        super.viewDidLoad()
      view.backgroundColor = .white
      view.addSubview(segmentControl)
     
      navigationItem.title = "время"
      navigationItem.largeTitleDisplayMode = .never

      updateViewConstraints()
    }
    

  @objc func isSegment() {
    guard let formatTime = DateFormat(rawValue: segmentControl.selectedSegmentIndex) else {return}
    dataSettings.first?.formatDate = formatTime
 
    do {
      try  DataBase.shared.context?.save()
    } catch {
      fatalError()
    }
    
    
    ParametersNetworkRequest.timeFormat = formatTime
  }
  
  override func updateViewConstraints() {
    super.updateViewConstraints()
    
    segmentControl.snp.makeConstraints { make in
      make.height.equalTo(60)
      make.leading.equalToSuperview().inset(16)
      make.trailing.equalToSuperview().inset(16)
      make.center.equalToSuperview()
    }
    
  }

}
