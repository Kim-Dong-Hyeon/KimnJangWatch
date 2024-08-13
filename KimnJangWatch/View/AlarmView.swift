//
//  AlarmView.swift
//  KimnJangWatch
//
//  Created by 김윤홍 on 8/12/24.
//

import UIKit

import SnapKit

class AlarmView: UIView {
  
  lazy var alarmList: UITableView = {
    let tableView = UITableView()
    tableView.backgroundColor = .dangn
    return tableView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.addSubview(alarmList)
    setConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setConstraints() {
    alarmList.snp.makeConstraints {
      $0.edges.equalTo(self.safeAreaLayoutGuide)
    }
  }
}
