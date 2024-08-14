//
//  MainTimerViewController.swift
//  KimnJangWatch
//
//  Created by 김승희 on 8/14/24.
//

import UIKit

import SnapKit

class SetTimerViewController: UIViewController {
  
  // MARK: mainTimerView UI 영역
  private lazy var timerPicker: UIDatePicker = {
    let timerPicker = UIDatePicker()
    timerPicker.datePickerMode = .countDownTimer
    return timerPicker
  }()
  
  private lazy var startButton: UIButton = {
    let button = UIButton()
    button.setTitle("시작", for: .normal)
    button.setTitleColor(.dangn, for: .normal)
    button.layer.cornerRadius = 35
    button.backgroundColor = .dangn.withAlphaComponent(0.2)
    button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    return button
  }()
  
  private lazy var cancelButton: UIButton = {
    let button = UIButton()
    button.setTitle("취소", for: .normal)
    button.setTitleColor(.darkGray, for: .normal)
    button.layer.cornerRadius = 35
    button.backgroundColor = .gray.withAlphaComponent(0.5)
    button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    return button
  }()
  
  private lazy var buttonStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 150
    return stackView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    setView()
  }
  
  @objc func startButtonTapped() {
    
  }
  
  private func setView() {
    view.addSubview(timerPicker)
    view.addSubview(buttonStackView)
    [cancelButton, startButton].forEach { buttonStackView.addArrangedSubview($0) }
    
    timerPicker.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.centerX.equalToSuperview()
    }
    
    cancelButton.snp.makeConstraints {
      $0.width.height.equalTo(70)
    }

    startButton.snp.makeConstraints {
      $0.width.height.equalTo(70)
    }
    
    buttonStackView.snp.makeConstraints {
      $0.top.equalTo(timerPicker.snp.bottom).offset(20)
      $0.centerX.equalToSuperview()
    }
  }

}
