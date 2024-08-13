//
//  TimerViewController.swift
//  KimnJangWatch
//
//  Created by 김승희 on 8/13/24.
//

import UIKit
import SnapKit

class TimerViewController: UIViewController {

  private lazy var timerPicker: UIDatePicker = {
    let timerPicker = UIDatePicker()
    timerPicker.datePickerMode = .countDownTimer
    return timerPicker
  }()
    
  private lazy var startButton: UIButton = {
    let button = UIButton()
    button.setTitle("시작", for: .normal)
    button.setTitleColor(.green, for: .normal)
    button.layer.cornerRadius = 35
    button.backgroundColor = .green.withAlphaComponent(0.2)
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
    
  private var buttonStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 150
    return stackView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    configUI()
    addSubViews()
  }
  
  @objc func editButtonTapped() {
    
  }
  
  @objc func startButtonTapped() {
    
  }
  
  @objc func cancelButtonTapped() {
    
  }
    
  func configUI() {
    view.backgroundColor = .white
    self.navigationController?.navigationBar.prefersLargeTitles = true
    self.navigationItem.largeTitleDisplayMode = .automatic
    self.title = "타이머"
    
    let editButton = UIBarButtonItem(title: "편집", style: .plain, target: self, action: #selector(editButtonTapped))
    editButton.tintColor = UIColor.dangn
    self.navigationItem.leftBarButtonItem = editButton
  }
  
  private func addSubViews() {
    view.addSubview(timerPicker)
    view.addSubview(buttonStackView)
    [cancelButton, startButton].forEach { buttonStackView.addArrangedSubview($0) }
    
    cancelButton.snp.makeConstraints {
      $0.width.height.equalTo(70)
    }
    
    startButton.snp.makeConstraints {
      $0.width.height.equalTo(70)
    }
    
    timerPicker.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.centerX.equalToSuperview()
    }
    
    buttonStackView.snp.makeConstraints {
      $0.top.equalTo(timerPicker.snp.bottom).offset(20)
      $0.centerX.equalToSuperview()
    }
    
  }
}
