//
//  AlarmSongViewController.swift
//  KimnJangWatch
//
//  Created by 김윤홍 on 8/17/24.
//

import UIKit

import RxCocoa
import RxSwift

class AlarmSongViewController: BaseTableViewController {
  
  var selectedIndexPath = BehaviorRelay<IndexPath?>(value: nil)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    titles = ["a", "b", "c", "d", "E", "F", "G", "h"]
    dataBinding()
    bind()
  }
  
  private func dataBinding() {
    tableView.rx.itemSelected
      .subscribe(onNext: { [weak self] indexPath in
        guard let self = self else { return }
        
        if let previousIndexPath = self.selectedIndexPath.value,
           let previousCell = self.tableView.cellForRow(at: previousIndexPath) {
          previousCell.accessoryView = nil
        }

        if let cell = self.tableView.cellForRow(at: indexPath) {
          let checkmarkImage = UIImage(systemName: "checkmark")?.withRenderingMode(.alwaysTemplate)
          let checkmarkImageView = UIImageView(image: checkmarkImage)
          checkmarkImageView.tintColor = .dangn
          cell.accessoryView = checkmarkImageView
        }
        self.selectedIndexPath.accept(indexPath)
      })
      .disposed(by: disposeBag)
  }
  
  override func configureUI() {
    navigationItem.title = "사운드"
  }
}
