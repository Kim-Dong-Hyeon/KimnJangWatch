//
//  MainTimerViewController.swift
//  KimnJangWatch
//
//  Created by 김승희 on 8/14/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

class SetTimerViewController: UIViewController {
  
  private let viewModel = TimerViewModel()
  private let disposeBag = DisposeBag()
  
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
    return button
  }()
  
  private lazy var pauseButton: UIButton = {
    let button = UIButton()
    button.setTitle("취소", for: .normal)
    button.setTitleColor(.darkGray, for: .normal)
    button.layer.cornerRadius = 35
    button.backgroundColor = .gray.withAlphaComponent(0.5)
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
    bind()
  }
  
  private func bind() {
    timerPicker.rx.countDownDuration
      .bind(to: viewModel.remainingTime)
      .disposed(by: disposeBag)
    
    startButton.rx.tap
      .subscribe(onNext: { [weak self] _ in
        self?.viewModel.startTimer()
      }).disposed(by: disposeBag)
    
    pauseButton.rx.tap
      .subscribe(onNext: { [weak self] _ in
        self?.viewModel.pauseTimer()
      }).disposed(by: disposeBag)
    
    viewModel.isRunnning
      .map { !$0 }
      .bind(to: startButton.rx.isEnabled)
      .disposed(by: disposeBag)
    
    viewModel.isRunnning
      .bind(to: pauseButton.rx.isEnabled)
      .disposed(by: disposeBag)
  }
  
  private func setView() {
    view.addSubview(timerPicker)
    view.addSubview(buttonStackView)
    [pauseButton, startButton].forEach { buttonStackView.addArrangedSubview($0) }
    
    timerPicker.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.centerX.equalToSuperview()
    }
    
    pauseButton.snp.makeConstraints {
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
