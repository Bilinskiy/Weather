//
//  MeasurementSystemViewController.swift
//  Weather
//
//  Created by Дмитрий Билинский on 12/17/24.
//

import UIKit
import SnapKit

class MeasurementSystemViewController: UIViewController {
  
 // var dataBase: DataBaseProtocol = DataBase()
  var dataSettings: [SettingsData] = []
  
  init(dataSettings: [SettingsData]) {
    self.dataSettings = dataSettings
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  lazy var segmentControl: UISegmentedControl = {
    var segment = UISegmentedControl()
    segment.insertSegment(withTitle: "metric", at: 0, animated: true)
    segment.insertSegment(withTitle: "imperial", at: 1, animated: true)
    segment.insertSegment(withTitle: "standard", at: 2, animated: true)
    segment.addTarget(self, action: #selector(isSegment), for: .valueChanged)
    return segment
  }()
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    guard let measurement = dataSettings.first?.measurement else {return}
    segmentControl.selectedSegmentIndex = measurement.rawValue
  }

    override func viewDidLoad() {
        super.viewDidLoad()
      view.backgroundColor = .white
      view.addSubview(segmentControl)
     
      navigationItem.title = "Измерения"
      navigationItem.largeTitleDisplayMode = .never
     
      updateViewConstraints()
    }
    
  
  @objc func isSegment() {
    guard let units = Units(rawValue: segmentControl.selectedSegmentIndex) else {return}
    dataSettings.first?.measurement = units
 
    do {
      try  DataBase.shared.context?.save()
    } catch {
      fatalError()
    }
    
   
    ParametersNetworkRequest.units = units
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
