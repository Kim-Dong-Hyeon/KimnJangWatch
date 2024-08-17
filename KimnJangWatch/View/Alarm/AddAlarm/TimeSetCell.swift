//
//  TimeSetCell.swift
//  KimnJangWatch
//
//  Created by 김윤홍 on 8/16/24.
//

import UIKit

import SnapKit

class TimeSetCell: UITableViewCell {
  
  static let identifier = "timeSetCell"
  
  private let label = UILabel()
  private let subLabel = UILabel()
  
  private let alarmSwitch: UISwitch = {
    let alarmSwitch = UISwitch()
    alarmSwitch.onTintColor = .dangn
    return alarmSwitch
  }()
  
  private let textField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "알람"
    textField.tintColor = .dangn
    textField.textAlignment = .right
    return textField
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configureUI()
    setConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureUI() {
    [
      label,
      subLabel,
      textField,
      alarmSwitch
    ].forEach { contentView.addSubview($0) }
  }
  
  private func setConstraints() {
    label.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.width.lessThanOrEqualTo(70)
      $0.top.bottom.leading.equalToSuperview().inset(10)
    }

    subLabel.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(10)
      $0.centerY.equalToSuperview()
    }
    
    textField.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(10)
      $0.centerY.equalToSuperview()
      $0.leading.equalTo(label.snp.trailing).offset(10)
    }
    
    alarmSwitch.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(10)
      $0.centerY.equalToSuperview()
    }
  }
  
  func configureCell(indexPath: Int) {
    let labelArray = ["반복", "레이블", "사운드", "다시 알림"]
    let subLabelArray = ["안 함 >", "래디얼 >"]
    label.text = labelArray[indexPath]
    subLabel.text = subLabelArray[Int(indexPath / 2)]
    
    switch indexPath {
    case 0:
      textField.isHidden = true
      alarmSwitch.isHidden = true
    case 1:
      alarmSwitch.isHidden = true
      subLabel.isHidden = true
    case 2:
      alarmSwitch.isHidden = true
      textField.isHidden = true
    case 3:
      textField.isHidden = true
      subLabel.isHidden = true
    default: break
    }
  }
}
