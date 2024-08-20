//
//  CurrentTimerViewController.swift
//  KimnJangWatch
//
//  Created by 김승희 on 8/14/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

class CurrentTimerViewController: UIViewController {
  
  private let viewModel = TimerViewModel.shared
  private let disposeBag = DisposeBag()
  
  // MARK: currentTimerView 영역
  private lazy var currentLabel: UILabel = {
    let label = UILabel()
    label.text = "현재 타이머"
    label.font = .systemFont(ofSize: 24, weight: .bold)
    return label
  }()
  
  lazy var currentTableView: UITableView = {
    let tableView = UITableView()
    tableView.register(CurrentTimerTableViewCell.self, forCellReuseIdentifier: CurrentTimerTableViewCell.id)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.backgroundColor = .gray
    tableView.isScrollEnabled = false
    return tableView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setView()
    bind()
  }

  private func tableViewHeight() -> CGFloat {
    let rowsCount = tableView(currentTableView, numberOfRowsInSection: 0)
    return CGFloat(rowsCount) * 100
  }
  
  private func updateTableViewHeight() {
    currentTableView.snp.updateConstraints {
      $0.height.equalTo(tableViewHeight())
    }
  }
  
  private func bind() {
    viewModel.timers
      .asDriver()
      .drive(onNext: { [weak self] _ in
        guard let self else { return }
        self.currentTableView.reloadData()
        self.updateTableViewHeight()
      }).disposed(by: disposeBag)
  }
  
  private func setView() {
    [currentLabel, currentTableView].forEach { view.addSubview($0) }
    
    currentLabel.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.equalToSuperview().offset(20)
    }
    
    currentTableView.snp.makeConstraints {
      $0.top.equalTo(currentLabel.snp.bottom).offset(10)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview().offset(-10)
      $0.height.equalTo(tableViewHeight())
    }
  }
}
  
extension CurrentTimerViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                 forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let timer = viewModel.timers.value[indexPath.row]
      viewModel.removeTimer(id: timer.id)
    }
  }
}
  
extension CurrentTimerViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.timers.value.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = currentTableView
      .dequeueReusableCell(withIdentifier: CurrentTimerTableViewCell.id, for: indexPath) as? CurrentTimerTableViewCell else {
      return UITableViewCell()
    }
    let timer = viewModel.timers.value[indexPath.row]
    cell.configCurrentCell(with: timer)
    return cell
  }
}
