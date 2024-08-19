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
  var selectedSound: (displayName: String, fileName: String)?
  var onSoundSelected: ((String) -> Void)?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    titles = addAlarmData.songs.map { $0.displayName } // 사용자에게 표시할 이름들만 titles에 저장
    dataBinding()
    bind()
  }
  
  private func dataBinding() {
    tableView.rx.itemSelected
      .subscribe(onNext: { [weak self] indexPath in
        guard let self = self else { return }
        
        // 이전에 선택된 셀의 체크마크 제거
        if let previousIndexPath = self.selectedIndexPath.value,
           let previousCell = self.tableView.cellForRow(at: previousIndexPath) {
          previousCell.accessoryView = nil
        }
        
        // 새로 선택된 셀에 체크마크 표시
        if let cell = self.tableView.cellForRow(at: indexPath) {
          let checkmarkImage = UIImage(systemName: "checkmark")?.withRenderingMode(.alwaysTemplate)
          let checkmarkImageView = UIImageView(image: checkmarkImage)
          checkmarkImageView.tintColor = .dangn
          cell.accessoryView = checkmarkImageView
          
          // 선택된 사운드 업데이트
          self.selectedSound = addAlarmData.songs[indexPath.row]
          self.onSoundSelected?(self.selectedSound?.fileName ?? "default")
        }
        
        self.selectedIndexPath.accept(indexPath)
        self.navigationController?.popViewController(animated: true)
      })
      .disposed(by: disposeBag)
  }
  
  override func configureUI() {
    navigationItem.title = "사운드"
  }
}
