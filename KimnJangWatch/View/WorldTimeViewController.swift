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
  
  var viewModel: WorldTimeViewModel!
  let disposeBag = DisposeBag()

  let tableView: UITableView = {
    let tv = UITableView()
    tv.register(WorldTimeCell.self, forCellReuseIdentifier: "WorldTimeCell")
    return tv
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel = WorldTimeViewModel()
    setNavigation()
    setTableView()
    setLayout()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.getIdArray()
  }
  
  func setNavigation() {
    title = "세계 시계"
    let editButton = UIBarButtonItem(title: "편집", style: .plain, target: self, action: nil)
    editButton.rx.tap
      .bind { _ in

      }
      .disposed(by: disposeBag)
    
    let plusButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: nil)

    editButton.rx.tap
      .bind { _ in
        
      }
      .disposed(by: disposeBag)
    
    plusButton.rx.tap
      .bind { [weak self] _ in
        self?.timeZoneModalPresent()
      }
      .disposed(by: disposeBag)
    
    navigationItem.leftBarButtonItem = editButton
    navigationItem.rightBarButtonItem = plusButton
  }
  
  func setTableView() {
    viewModel.ids
      .bind(to: tableView.rx.items(cellIdentifier: "WorldTimeCell",
                                   cellType: WorldTimeCell.self)) 
    { (row, item, cell) in
      cell.countryLabel.text = item
      print(item)
    }
      .disposed(by: disposeBag)
  }
  
  func setLayout() {
    view.backgroundColor = .systemBackground
    
    [tableView]
      .forEach {
        view.addSubview($0)
      }
    
    tableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  func timeZoneModalPresent() {
    let timezoneModal = TimeZoneModalViewController()
    timezoneModal.modalPresentationStyle = .fullScreen
    present(timezoneModal, animated: true)
  }
}
