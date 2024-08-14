//
//  LapViewCell.swift
//  KimnJangWatch
//
//  Created by bloom on 8/14/24.
//

import UIKit

import SnapKit

final class LapViewCell: UITableViewCell {
  static let id = "LabViewCell"
  let lapCountLabel = {
    let x = UILabel()
    x.text = "랩1"
    x.textAlignment = .left
    x.font = UIFont.systemFont(ofSize: 18)
    return x
  }()
  let timeLabel = {
    let x = UILabel()
    x.text = "00:00.00"
    x.textAlignment = .right
    x.font = UIFont.systemFont(ofSize: 18)
    return x
  }()
//half line
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.configureUI()
    
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  private func configureUI(){
    self.addSubview(lapCountLabel)
    self.addSubview(timeLabel)
    lapCountLabel.snp.makeConstraints{
      $0.leading.equalTo(contentView).inset(20)
      $0.centerY.equalToSuperview()
      
    }
    timeLabel.snp.makeConstraints{
      $0.trailing.equalTo(contentView).inset(20)
      $0.centerY.equalToSuperview()
    }
    
  }

  
}
