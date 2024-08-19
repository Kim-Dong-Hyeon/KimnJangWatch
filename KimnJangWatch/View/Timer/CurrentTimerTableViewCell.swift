//
//  CurrentTimerTableViewCell.swift
//  KimnJangWatch
//
//  Created by 김승희 on 8/13/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

class CurrentTimerTableViewCell: UITableViewCell {
  
  static let id = "currentTimerViewCell"
  private var timerViewModel = TimerViewModel.shared
  private var disposeBag = DisposeBag()
  private var actionDisposeBag = DisposeBag()
  
  private let timeLabel: UILabel = {
    let label = UILabel()
    label.text = "00:00"
    label.font = .systemFont(ofSize: 30, weight: .semibold)
    return label
  }()
  
  private let startButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "currentStartButton"), for: .normal)
    button.isHidden = true
    return button
  }()
  
  private let pauseButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "currentStopButton"), for: .normal)
    return button
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setCell()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setCell() {
    [timeLabel, startButton, pauseButton].forEach { contentView.addSubview($0) }
    
    timeLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(10)
    }
    
    startButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-10)
      $0.width.height.equalTo(50)
      $0.centerY.equalTo(timeLabel)
    }
    pauseButton.snp.makeConstraints {
      $0.edges.equalTo(startButton)
    }
  }
  
  func configCurrentCell(with timer: TimerModel) {
    disposeBag = DisposeBag()
    
    timer.remainingTime
      .map { String(format: "%02d:%02d", Int($0)/60, Int($0)%60) }
      .bind(to: timeLabel.rx.text)
      .disposed(by: disposeBag)
    
    timer.isRunning
      .subscribe(onNext: { [weak self] isRunning in
        self?.startButton.isHidden = isRunning
        self?.pauseButton.isHidden = !isRunning
      }).disposed(by: disposeBag)
    
    setButtonAction(timer: timer)
  }
    
  private func setButtonAction(timer: TimerModel) {
    actionDisposeBag = DisposeBag()
    
    pauseButton.rx.tap
      .subscribe(onNext: { [weak self] in
        guard let self else { return }
        timer.isRunning.accept(false)
        self.timerViewModel.pauseTimer(id: timer.id)
        self.disposeBag = DisposeBag()
      }).disposed(by: actionDisposeBag)
    
    startButton.rx.tap
      .subscribe(onNext: { [weak self] in
        guard let self else { return }
        timer.isRunning.accept(true)
        self.timerViewModel.startTimer(id: timer.id)
        self.configCurrentCell(with: timer)
      }).disposed(by: actionDisposeBag)
  }
  
}
