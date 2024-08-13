//
//  WorldTimeCell.swift
//  KimnJangWatch
//
//  Created by Soo Jang on 8/12/24.
//

import UIKit

import SnapKit

class WorldTimeCell: UITableViewCell {
  
  let countryLabel: UILabel = {
    let label = UILabel()
    label.text = "abc"
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
    
    [countryLabel]
      .forEach {
        self.addSubview($0)
      }
    
    countryLabel.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }
  
}
