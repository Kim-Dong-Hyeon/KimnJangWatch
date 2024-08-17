//
//  RecentTimerViewController.swift
//  KimnJangWatch
//
//  Created by 김승희 on 8/14/24.
//

import UIKit

import SnapKit

class RecentTimerViewController: UIViewController {
  
  // MARK: recentTimerView 영역
  private lazy var recentLabel: UILabel = {
    let label = UILabel()
    label.text = "최근 타이머"
    label.font = .systemFont(ofSize: 24, weight: .bold)
    return label
  }()
  
  private lazy var recentTableView: UITableView = {
    let tableView = UITableView()
    tableView.register(RecentTimerTableViewCell.self, forCellReuseIdentifier: RecentTimerTableViewCell.id)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.backgroundColor = .gray
    tableView.isScrollEnabled = false
    return tableView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    setRecentTimerView()
  }
  
  private func setRecentTimerView() {
    [recentLabel, recentTableView].forEach { view.addSubview($0) }
    
    recentLabel.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.equalToSuperview().offset(20)
    }
    
    recentTableView.snp.makeConstraints {
      $0.top.equalTo(recentLabel.snp.bottom).offset(10)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview().offset(-10)
      $0.height.equalTo(tableViewHeight())
    }
  }
  
  private func tableViewHeight() -> CGFloat {
    let rowsCount = tableView(recentTableView, numberOfRowsInSection: 0)
    return CGFloat(rowsCount) * 100
  }
}

extension RecentTimerViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
}

extension RecentTimerViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = recentTableView
      .dequeueReusableCell(withIdentifier: RecentTimerTableViewCell.id, for: indexPath) as? RecentTimerTableViewCell else {
      return UITableViewCell()
    }
    return cell
  }
}

