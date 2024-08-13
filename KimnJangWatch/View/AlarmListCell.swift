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
    label.text = "14:30"
    return label
  }()
  
  lazy var dayLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 10)
    label.textColor = .lightGray
    label.text = "알람"
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
      $0.leading.equalTo(timeLabel)
      $0.top.equalTo(timeLabel.snp.bottom).offset(5)
      $0.bottom.equalToSuperview().inset(10)
    }
    
    onOff.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(10)
      $0.centerY.equalToSuperview()
    }
  }
}
