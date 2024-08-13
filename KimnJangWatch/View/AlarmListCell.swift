//
//  AlarmListCell.swift
//  KimnJangWatch
//
//  Created by 김윤홍 on 8/12/24.
//

import UIKit

import SnapKit

class AlarmListCell: UITableViewCell {
  
  static let identifier = "alarmCell"
  
  lazy var timeLabel: UILabel = {
    let label = UILabel()
    label.font = .boldSystemFont(ofSize: 30)
    label.textColor = .lightGray
    return label
  }()
  
  lazy var dayLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 10)
    label.textColor = .lightGray
    return label
  }()
  
  lazy var onOff = UISwitch()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    [
      timeLabel,
      dayLabel,
      onOff
    ].forEach { contentView.addSubview($0) }
    setConstraints()
    self.backgroundColor = .red
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setConstraints() {
    timeLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(10)
      $0.top.equalToSuperview().inset(10)
    }
    
    dayLabel.snp.makeConstraints {
      $0.leading.equalToSuperview()
      $0.top.equalTo(timeLabel.snp.bottom).inset(5)
    }
    
    onOff.snp.makeConstraints {
      $0.trailing.equalToSuperview()
    }
    
  }
}
