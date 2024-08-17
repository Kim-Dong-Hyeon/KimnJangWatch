//
//  WorldTimeViewController.swift
//  KimnJangWatch
//
//  Created by Soo Jang on 8/12/24.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift

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
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    viewModel.getIdArray()
  }
  
  private func setNavigation() {
    title = "세계 시계"
    navigationController?.navigationBar.prefersLargeTitles = true
    let editButton = UIBarButtonItem(title: "편집", style: .plain, target: self, action: nil)
    editButton.tintColor = .dangn
    editButton.rx.tap
      .bind { _ in

      }
      .disposed(by: disposeBag)
    
    let plusButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: nil)
    plusButton.tintColor = .dangn
    
    plusButton.rx.tap
      .bind { [weak self] _ in
        self?.timeZoneModalPresent()
      }
      .disposed(by: disposeBag)
    
    navigationItem.leftBarButtonItem = editButton
    navigationItem.rightBarButtonItem = plusButton
  }
  
  private func setTableView() {
    TimeZoneList.shared.added
      .bind(to: tableView.rx.items(cellIdentifier: "WorldTimeCell",
                                   cellType: WorldTimeCell.self)) 
    { [weak self] (row, item, cell) in
      guard let self else { return }
      cell.cityLabel.text = item.kor.getCityName()
      cell.meridiemLabel.text = self.viewModel.getCurrentTime(identifier: item.eng).meridiem
      cell.timeLabel.text = self.viewModel.getCurrentTime(identifier: item.eng).time
    }
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
