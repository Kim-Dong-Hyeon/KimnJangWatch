//
//  SetTimerViewController.swift
//  KimnJangWatch
//
//  Created by 김승희 on 8/14/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

class SetTimerViewController: UIViewController {
  
  private let viewModel = TimerViewModel.shared
  private let disposeBag = DisposeBag()
  
  // MARK: mainTimerView UI 영역
  private lazy var timerPicker: UIPickerView = {
    let timerPicker = UIPickerView()
    timerPicker.delegate = self
    timerPicker.dataSource = self
    return timerPicker
  }()
  
  private var hours = 0
  private var minutes = 0
  private var seconds = 0
  
  private lazy var startButton: UIButton = {
    let button = UIButton()
    button.setTitle("시작", for: .normal)
    button.setTitleColor(.dangn, for: .normal)
    button.layer.cornerRadius = 35
    button.backgroundColor = .dangn.withAlphaComponent(0.2)
    return button
  }()
  
  private lazy var cancelButton: UIButton = {
    let button = UIButton()
    button.setTitle("취소", for: .normal)
    button.setTitleColor(.darkGray, for: .normal)
    button.layer.cornerRadius = 35
    button.backgroundColor = .gray.withAlphaComponent(0.5)
    button.isEnabled = false
    return button
  }()
  
  
  private lazy var buttonStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 150
    return stackView
  }()

  // MARK: 뷰 생애주기 관리
  override func viewDidLoad() {
    super.viewDidLoad()
    setView()
    bind()
  }
  
  // MARK: 로직
  private func bind() {
    startButton.rx.tap
      .subscribe(onNext: { [weak self] _ in
        guard let self else { return }
        let timerTime = setTime()
        self.viewModel.setNewTimer(time: timerTime)
      }).disposed(by: disposeBag)
    
    cancelButton.rx.tap
      .subscribe(onNext: { [weak self] _ in
        guard let self, let firstTimer = self.viewModel.timers.value.first else { return }
        self.viewModel.cancelTimer(id: firstTimer.id)
        print("cancel button tapped")
      }).disposed(by: disposeBag)
    
    viewModel.timers
      .map { !$0.isEmpty }
      .bind(to: cancelButton.rx.isEnabled)
      .disposed(by: disposeBag)
  }
  
  private func setTime() -> TimeInterval {
    let time = (hours * 3600) + (minutes * 60) + seconds
    return TimeInterval(time)
  }
  
  // MARK: 제약조건
  private func setView() {
    [timerPicker, buttonStackView].forEach { view.addSubview($0) }
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

extension SetTimerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 3
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    switch component {
    case 0: return 24
    case 1: return 60
    case 2: return 60
    default: return 0
    }
  }
  
  func pickerView(_ pickerView: UIPickerView,
                  titleForRow row: Int,
                  forComponent component: Int) -> String? {
    switch component {
    case 0: return "\(row)시간"
    case 1: return "\(row)분"
    case 2: return "\(row)초"
    default: return nil
    }
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    switch component {
    case 0: hours = row
    case 1: minutes = row
    case 2: seconds = row
    default: break
    }
  }
}
