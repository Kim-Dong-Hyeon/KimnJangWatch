//
//  StopWatchController.swift
//  KimnJangWatch
//
//  Created by bloom on 8/12/24.
//

import UIKit

import SnapKit

final class StopWatchController: UIViewController {
  private let viewModel = StopWatchViewModel()
  let timeLabel = {
    let label = UILabel()
    label.font = UIFont.monospacedDigitSystemFont(ofSize: 48, weight: .bold)
    label.textAlignment = .center
    label.textColor = .black
    label.text = "00:00.00"
    return label
  }()
  lazy var lapResetButton = {
    let button = UIButton()
    button.setTitle("랩", for: .normal)
    button.setTitleColor(.red, for: .normal)
    button.layer.cornerRadius = 35
    button.backgroundColor = UIColor.lightGray
    button.isEnabled = false
    button.addTarget(self, action: #selector(didTapLapResetButton), for: .touchUpInside)
    return button
  }()
  lazy var startStopButton = {
    let button = UIButton()
    button.setTitle("시작", for: .normal)
    button.setTitleColor(.green, for: .normal)
    button.layer.cornerRadius = 35
    button.backgroundColor = UIColor.dangn
    button.addTarget(self, action: #selector(didTapStartStopButton), for: .touchUpInside)
    return button
  }()
  lazy var timeLabTableView = {
    let tableView = UITableView()
    tableView.register(LapViewCell.self, forCellReuseIdentifier: LapViewCell.id)
    tableView.dataSource = self
    tableView.delegate = self
    return tableView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()
    self.makeConstraints()
  }
  private func configureUI() {
    self.view.backgroundColor = .white
    navigationItem.title = "스톱워치"
    self.navigationController?.navigationBar.prefersLargeTitles = true
    self.navigationItem.largeTitleDisplayMode = .always
    [   
      lapResetButton,
      startStopButton,
      timeLabel,
      timeLabTableView
    ].forEach
    { self.view.addSubview($0) }
    
  }

    private func makeConstraints() {
      timeLabel.snp.makeConstraints {
        $0.centerX.equalToSuperview()
        $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(60)
      }
      lapResetButton.snp.makeConstraints {
        $0.leading.equalTo(self.view.safeAreaLayoutGuide).inset(60)
        $0.top.equalTo(timeLabel.snp.bottom).offset(60)
        $0.height.width.equalTo(70)
      }
      startStopButton.snp.makeConstraints {
        $0.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(60)
        $0.top.equalTo(timeLabel.snp.bottom).offset(60)
        $0.height.width.equalTo(70)
      }

      timeLabTableView.snp.makeConstraints{
        $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(30)
        $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
        $0.height.equalTo(300)
      }


    }
    
  
  
}
extension StopWatchController {
  @objc private func didTapStartStopButton() {
    
    switch viewModel.watchStatus {
    case .start:
      startStopButton.setTitle("시작", for: .normal)
      lapResetButton.setTitle("재시작", for: .normal)
      lapResetButton.isEnabled = true
    case .stop:
      startStopButton.setTitle("중단", for: .normal)
      lapResetButton.setTitle("랩", for: .normal)
      lapResetButton.isEnabled = true
    }
  }
  @objc private func didTapLapResetButton(){
    switch viewModel.watchStatus {
    case .start:
      viewModel
      lapResetButton.setTitle("랩", for: .normal)
      lapResetButton.isEnabled = false
    case .stop:
      viewModel
      timeLabTableView.reloadData()
      
    }
  }
  
  
}

extension StopWatchController: UITableViewDelegate,UITableViewDataSource {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    60
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.recordList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: LapViewCell.id, for: indexPath) as? LapViewCell
    guard let safecell = cell else { return UITableViewCell() }
    safecell
    return safecell
  }
  
  
}



