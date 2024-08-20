//
//  WorldTimeViewController.swift
//  KimnJangWatch
//
//  Created by Soo Jang on 8/12/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

class WorldTimeViewController: UIViewController {
  
  private var viewModel: WorldTimeViewModel!
  private let disposeBag = DisposeBag()
  
  private let tableView: UITableView = {
    let tv = UITableView()
    tv.register(WorldTimeCell.self, forCellReuseIdentifier: "WorldTimeCell")
    tv.rowHeight = 90
    return tv
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel = WorldTimeViewModel()
    setNavigation()
    setTableView()
    setLayout()
    deleteCell()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    viewModel.getIdArray()
  }
  
  private func setNavigation() {
    title = "세계 시계"
    navigationController?.navigationBar.prefersLargeTitles = true
    //    let editButton = UIBarButtonItem(title: "편집", style: .plain, target: self, action: nil)
    //    editButton.tintColor = .dangn
    //    editButton.rx.tap
    //      .bind { _ in
    //
    //      }
    //      .disposed(by: disposeBag)
    let plusButton = UIBarButtonItem(
      image: UIImage(systemName: "plus"),
      style: .plain,
      target: self,
      action: nil
    )
    plusButton.tintColor = .dangn
    
    plusButton.rx.tap
      .bind { [weak self] _ in
        self?.timeZoneModalPresent()
      }
      .disposed(by: disposeBag)
    
    //    navigationItem.leftBarButtonItem = editButton
    navigationItem.rightBarButtonItem = plusButton
  }
  
  private func setTableView() {
    tableView.rx.setDelegate(self).disposed(by: disposeBag)
    
    TimeZoneList.shared.added
      .bind(to: tableView.rx
        .items(cellIdentifier: "WorldTimeCell",
               cellType: WorldTimeCell.self))
    { [weak self] (row, item, cell) in
      guard let self else { return }
      cell.cityLabel.text = item.kor.getCityName()
      cell.meridiemLabel.text = self.viewModel.getCurrentTime(identifier: item.eng).meridiem
      cell.timeLabel.text = self.viewModel.getCurrentTime(identifier: item.eng).time
      cell.selectionStyle = .none
    }
    .disposed(by: disposeBag)
  }
  
  private func deleteCell() {
    tableView.rx.itemDeleted
      .subscribe(onNext: { indexPath in
        var currentItems = TimeZoneList.shared.added.value
        currentItems.remove(at: indexPath.row)
        TimeZoneList.shared.added.accept(currentItems)
      })
      .disposed(by: disposeBag)
  }
  
  private func setLayout() {
    view.backgroundColor = .systemBackground
    
    [tableView]
      .forEach {
        view.addSubview($0)
      }
    
    tableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  private func timeZoneModalPresent() {
    let timezoneModal = TimeZoneModalViewController()
    timezoneModal.modalPresentationStyle = .pageSheet
    present(timezoneModal, animated: true) { [weak self] in
      self?.viewModel.updateCityFromTimeZoneList()
    }
  }
}

extension WorldTimeViewController: UITableViewDelegate {
  func tableView(
    _ tableView: UITableView,
    titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath
  ) -> String? {
    return "삭제"
  }
}
