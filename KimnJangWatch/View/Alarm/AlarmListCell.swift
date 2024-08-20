//
//  AlarmListCell.swift
//  KimnJangWatch
//
//  Created by 김윤홍 on 8/12/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

class AlarmListCell: UITableViewCell {
  
  static let identifier = "alarmCell"
  let disposeBag = DisposeBag()
  
  let timeLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 50, weight: .thin)
    label.textColor = .lightGray
    label.text = ""
    return label
  }()
  
  let dayLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 10)
    label.textColor = .lightGray
    label.text = "알람"
    return label
  }()
  
  let onOff: UISwitch = {
    let onOff = UISwitch()
    onOff.onTintColor = UIColor.dangn
    return onOff
  }()
  
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
  
  private func StringDay(_ day: Int) -> String {
    switch day {
    case 0: return "일"
    case 1: return "월"
    case 2: return "화"
    case 3: return "수"
    case 4: return "목"
    case 5: return "금"
    case 6: return "토"
    default: return ""
    }
  }
  
  func configure(time: String, days: [Int]) {
    timeLabel.text = time
    let dayStrings = days.map { StringDay($0) }
    dayLabel.text = dayStrings.joined(separator: ", ")
  }
  
  private func setConstraints() {
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
