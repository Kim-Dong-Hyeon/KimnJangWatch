//
//  AddAlarmView.swift
//  KimnJangWatch
//
//  Created by 김윤홍 on 8/13/24.
//

import UIKit

import SnapKit

class AddAlarmView: UIView {
  
  let timeView: UIDatePicker = {
    let datePicker = UIDatePicker()
    datePicker.datePickerMode = .time
    datePicker.preferredDatePickerStyle = .wheels
    datePicker.locale = Locale(identifier: "ko_GB")
    return datePicker
  }()
  
  private let timeSetList: UIStackView = {
    let stackView = UIStackView()
    stackView.backgroundColor = .lightGray
    stackView.layer.cornerRadius = 10
    stackView.distribution = .fillEqually
    stackView.axis = .vertical
    return stackView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    [
      timeView,
      timeSetList
    ].forEach { self.addSubview($0) }
    setConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setConstraints() {
    timeView.snp.makeConstraints {
      $0.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
      $0.height.equalTo(self.frame.height / 4)
    }
    
    timeSetList.snp.makeConstraints {
      $0.top.equalTo(timeView.snp.bottom).inset(5)
      $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(15)
      $0.height.equalTo(self.frame.height / 4.5)
    }
  }
}
