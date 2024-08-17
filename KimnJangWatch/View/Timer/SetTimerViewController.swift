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
  
  private let viewModel = TimerViewModel.shared
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

  override func viewDidLoad() {
    super.viewDidLoad()
    setView()
    bind()
  }
  
  private func bind() {
    startButton.rx.tap
      .subscribe(onNext: { [weak self] _ in
        guard let self else { return }
        self.viewModel.setNewTimer(time: self.timerPicker.countDownDuration)
        print("start button tapped")
        print("Current timers in ViewModel: \(self.viewModel.timers.value.map { $0.remainingTime.value })")
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
