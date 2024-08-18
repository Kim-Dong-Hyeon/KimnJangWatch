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
  
  var checkedCell = BehaviorRelay<[IndexPath]>(value: [])
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    titles = ["일요일마다","월요일마다","화요일마다","수요일마다","목요일마다","금요일마다","토요일마다"]
    dataBinding()
    //왜 한번더 호출을 해야하는지.. 몰게씅ㅁ .
    bind()
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
  
  override func configureUI() {
    navigationItem.title = "반복"
  }
}
