//
//  WorldTimeCell.swift
//  KimnJangWatch
//
//  Created by Soo Jang on 8/12/24.
//

import UIKit

import SnapKit

class WorldTimeCell: UITableViewCell {
  
  let cityLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
    return label
  }()
  
  let meridiemLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
    return label
  }()
  
  let timeLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 56, weight: .light)
    label.text = "11:11"
    label.textAlignment = .left
    return label
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setLayout() {
    self.backgroundColor = .systemBackground
    
    [cityLabel, meridiemLabel, timeLabel]
      .forEach {
        self.addSubview($0)
      }
    
    cityLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(16)
      $0.firstBaseline.equalTo(timeLabel.snp.firstBaseline)
    }
    
    meridiemLabel.snp.makeConstraints {
      $0.trailing.equalTo(timeLabel.snp.leading).offset(-8)
      $0.firstBaseline.equalTo(timeLabel.snp.firstBaseline)
    }
    
    timeLabel.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-16)
      $0.centerY.equalToSuperview()
    }
  }
  
}
