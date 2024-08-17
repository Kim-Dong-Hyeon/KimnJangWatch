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
    label.font = UIFont.systemFont(ofSize: 64, weight: .thin)
    label.text = "11:11"
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
      $0.centerY.equalToSuperview()
    }
    
    meridiemLabel.snp.makeConstraints {
      $0.trailing.equalTo(timeLabel.snp.leading).offset(-16)
      $0.centerY.equalToSuperview()
    }
    
    timeLabel.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-16)
      $0.centerY.equalToSuperview()
    }
  }
  
}
