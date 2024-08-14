//
//  CurrentTimerViewController.swift
//  KimnJangWatch
//
//  Created by 김승희 on 8/14/24.
//

import UIKit

import SnapKit

class CurrentTimerViewController: UIViewController {
  
  // MARK: currentTimerView 영역
  private lazy var currentLabel: UILabel = {
    let label = UILabel()
    label.text = "현재 타이머"
    label.font = .systemFont(ofSize: 24, weight: .bold)
    return label
  }()
  
  private lazy var currentTableView: UITableView = {
    let tableView = UITableView()
    tableView.register(CurrentTimerTableViewCell.self, forCellReuseIdentifier: CurrentTimerTableViewCell.id)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.backgroundColor = .gray
    return tableView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setView()
  }
  
  private func setView() {
    [currentLabel, currentTableView].forEach { view.addSubview($0) }
    
    currentLabel.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.equalToSuperview().offset(20)
    }
    
    currentTableView.snp.makeConstraints {
      $0.top.equalTo(currentLabel.snp.bottom).offset(10)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview().offset(-10)
    }
  }
}
  
extension CurrentTimerViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
}
  
extension CurrentTimerViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = currentTableView
      .dequeueReusableCell(withIdentifier: CurrentTimerTableViewCell.id, for: indexPath) as? CurrentTimerTableViewCell else {
      return UITableViewCell()
    }
    return cell
  }
}

