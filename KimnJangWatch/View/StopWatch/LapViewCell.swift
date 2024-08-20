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
  let lapCountLabel = UILabel()
  let timeLabel = UILabel()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.configureUI()
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureUI() {
    self.lapCountLabel.textAlignment = .left
    self.lapCountLabel.font = UIFont.systemFont(ofSize: 18)
    self.timeLabel.textAlignment = .right
    self.timeLabel.font = UIFont.systemFont(ofSize: 18)
    [
      lapCountLabel,
      timeLabel
    ].forEach{ self.addSubview($0) }
    self.lapCountLabel.snp.makeConstraints {
      $0.leading.equalTo(contentView).inset(20)
      $0.centerY.equalToSuperview()
    }
    self.timeLabel.snp.makeConstraints {
      $0.trailing.equalTo(contentView).inset(20)
      $0.centerY.equalToSuperview()
    }
  }
}
