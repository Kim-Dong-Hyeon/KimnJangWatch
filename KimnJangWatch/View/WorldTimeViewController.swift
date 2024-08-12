//
//  WorldTimeViewController.swift
//  KimnJangWatch
//
//  Created by Soo Jang on 8/12/24.
//

import UIKit

import RxCocoa
import RxSwift

class WorldTimeViewController: UIViewController {
  
  var viewModel: WorldTimeViewModel!
  let disposeBag = DisposeBag()

  let tableView: UITableView = {
    let tv = UITableView()
    return tv
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel = WorldTimeViewModel()
    setNavigation()
    setTableView()
    setLayout()
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
    
  }
  
  func setLayout() {
    view.backgroundColor = .white
  }
  
  func timeZoneModalPresent() {
    let timezoneModal = TimeZoneModalViewController()
    present(timezoneModal, animated: true)
  }
  
}

