//
//  StopWatchController.swift
//  KimnJangWatch
//
//  Created by bloom on 8/12/24.
//

import UIKit

import SnapKit

final class StopWatchController: UIViewController {
  private let viewModel = StopWatchViewModel()
  private let timeLabel = {
    let label = UILabel()
    label.font = UIFont.monospacedDigitSystemFont(ofSize: 48, weight: .bold)
    label.textAlignment = .center
    label.textColor = .black
    label.text = "00:00.00"
    return label
  }()
  private let lapResetButton = {
    let button = UIButton()
    button.setTitle("랩", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.layer.cornerRadius = 35
    button.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
    button.isEnabled = false
    return button
  }()
  private let startStopButton = {
    let button = UIButton()
    button.setTitle("시작", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.layer.cornerRadius = 35
    button.backgroundColor = UIColor.dangn.withAlphaComponent(0.7)
    return button
  }()
  private let timeLabTableView = UITableView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()
    self.makeConstraints()
    self.viewModel.onTimeUpdate = { [weak self] timeString in
      self?.timeLabel.text = timeString }
    self.viewModel.onLapUpdate = { [weak self] _ in
      self?.timeLabTableView.reloadData() }
    self.setupActions()
  }
  
  private func setupActions() {
    self.lapResetButton.addTarget(self, action: #selector(didTapLapResetButton), for: .touchUpInside)
    self.startStopButton.addTarget(self, action: #selector(didTapStartStopButton), for: .touchUpInside)
    self.timeLabTableView.register(LapViewCell.self, forCellReuseIdentifier: LapViewCell.id)
    self.timeLabTableView.dataSource = self
    self.timeLabTableView.delegate = self
  }
  
  private func configureUI() {
    self.view.backgroundColor = .white
    self.navigationItem.title = "스톱워치"
    self.navigationController?.navigationBar.prefersLargeTitles = true
    self.navigationItem.largeTitleDisplayMode = .always
    [
      lapResetButton,
      startStopButton,
      timeLabel,
      timeLabTableView
    ].forEach
    { self.view.addSubview($0) }
  }
  
  private func makeConstraints() {
    self.timeLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(60)
    }
    self.lapResetButton.snp.makeConstraints {
      $0.leading.equalTo(self.view.safeAreaLayoutGuide).inset(60)
      $0.top.equalTo(timeLabel.snp.bottom).offset(60)
      $0.height.width.equalTo(70)
    }
    self.startStopButton.snp.makeConstraints {
      $0.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(60)
      $0.top.equalTo(timeLabel.snp.bottom).offset(60)
      $0.height.width.equalTo(70)
    }
    self.timeLabTableView.snp.makeConstraints {
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(30)
      $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
      $0.height.equalTo(300)
    }
  }
  
  @objc private func didTapStartStopButton() {
    viewModel.didTapStartStopButton()
    self.updateButtonStates()
  }
  
  @objc private func didTapLapResetButton() {
    viewModel.didTapLapResetButton()
    self.updateButtonStates()
  }
  
  private func updateButtonStates() {
    switch viewModel.watchStatus {
    case .start:
      self.startStopButton.setTitle("중지", for: .normal)
      self.lapResetButton.setTitle("랩", for: .normal)
      
      self.lapResetButton.isEnabled = true
    case .pause:
      self.startStopButton.setTitle("시작", for: .normal)
      self.lapResetButton.setTitle("재설정", for: .normal)
    case .stop:
      self.startStopButton.setTitle("시작", for: .normal)
      self.lapResetButton.setTitle("랩", for: .normal)
      self.lapResetButton.isEnabled = false
    }
  }
}

extension StopWatchController: UITableViewDelegate,UITableViewDataSource {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    50
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.recordList.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: LapViewCell.id, for: indexPath) as? LapViewCell
    guard let safecell = cell else { return UITableViewCell() }
    safecell.timeLabel.text = viewModel.recordList[indexPath.row]
    safecell.lapCountLabel.text = "랩 \(viewModel.lapCounts[indexPath.row])"
    return safecell
  }
}



