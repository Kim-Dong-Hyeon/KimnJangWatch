//
//  DayTableViewController.swift
//  KimnJangWatch
//
//  Created by 김윤홍 on 8/17/24.
//

import UIKit

import RxCocoa
import RxSwift

class DayTableViewController: BaseTableViewController {
  
  var time: String
  var checkedCell = BehaviorRelay<[IndexPath]>(value: [])
  let viewModel = AlarmViewModel()
  
  init(time: String) {
    self.time = time
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    titles = ["일요일마다", "월요일마다", "화요일마다", "수요일마다", "목요일마다", "금요일마다", "토요일마다"]
    dataBinding()
    bind()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    reloadCheckedCells()
  }
  
  private func dataBinding() {
    tableView.rx.itemSelected
      .subscribe(onNext: { [weak self] indexPath in
        guard let self = self else { return }
        
        var checkedCells = self.checkedCell.value
        if checkedCells.contains(indexPath) {
          if let cell = self.tableView.cellForRow(at: indexPath) {
            cell.accessoryView = nil
          }
          checkedCells.removeAll(where: { $0 == indexPath })
        } else {
          if let cell = self.tableView.cellForRow(at: indexPath) {
            let checkmarkImage = UIImage(systemName: "checkmark")?.withRenderingMode(.alwaysTemplate)
            let checkmarkImageView = UIImageView(image: checkmarkImage)
            checkmarkImageView.tintColor = .dangn
            cell.accessoryView = checkmarkImageView
          }
          checkedCells.append(indexPath)
        }
        self.checkedCell.accept(checkedCells)
      }).disposed(by: disposeBag)
  }
  
  override func saveData() {
    let dayArray = checkedCell.value.map { $0.row }
    self.viewModel.addTime(day: dayArray, time: time)
  }
  
  override func configureUI() {
    navigationItem.title = "반복"
  }
  
  private func reloadCheckedCells() {
    if let dayArray = UserDefaults.standard.dictionary(forKey: "times") as? [String: [Int]],
       let savedDays = dayArray[time] {
      let indexPaths = savedDays.map { IndexPath(row: $0, section: 0) }
      checkedCell.accept(indexPaths)
      tableView.reloadData()
      DispatchQueue.main.async {
        for indexPath in indexPaths {
          if let cell = self.tableView.cellForRow(at: indexPath) {
            let checkmarkImage = UIImage(systemName: "checkmark")?.withRenderingMode(.alwaysTemplate)
            let checkmarkImageView = UIImageView(image: checkmarkImage)
            checkmarkImageView.tintColor = .dangn
            cell.accessoryView = checkmarkImageView
          }
        }
      }
    }
  }
}
