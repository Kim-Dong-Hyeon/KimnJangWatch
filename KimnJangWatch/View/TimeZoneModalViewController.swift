//
//  TimeZoneSearchViewController.swift
//  KimnJangWatch
//
//  Created by Soo Jang on 8/12/24.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift

class TimeZoneModalViewController: UIViewController {
  
  var viewModel: TimeZoneModalViewModel!
  let disposeBag = DisposeBag()
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "국가 선택"
    label.textAlignment = .center
    return label
  }()
  
  let searchBar: UISearchBar = {
    let sb = UISearchBar()
    sb.placeholder = "검색"
    return sb
  }()
  
  let tableView: UITableView = {
    let tv = UITableView()
    return tv
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel = TimeZoneModalViewModel()
    tableView.dataSource = self
    setLayout()
    tableViewTapped()
  }

  func tableViewTapped() {
    tableView.rx.itemSelected
      .subscribe(onNext: { [weak self] indexPath in
        print(self?.viewModel.identifiers[indexPath.row])
        self?.dismiss(animated: true)
      })
      .disposed(by: disposeBag)
  }
  
  func setLayout() {
    view.backgroundColor = .systemBackground
    
    [titleLabel, searchBar, tableView]
      .forEach {
        view.addSubview($0)
      }
    titleLabel.snp.makeConstraints {
      $0.top.left.right.equalToSuperview().inset(16)
    }
    
    searchBar.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(8)
      $0.left.right.equalToSuperview()
    }
    
    tableView.snp.makeConstraints {
      $0.top.equalTo(searchBar.snp.bottom).offset(8)
      $0.left.right.bottom.equalToSuperview()
    }
  }
}

extension TimeZoneModalViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.identifiers.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    cell.textLabel?.text = viewModel.identifiers[indexPath.row].kor
    return cell
  }
  
  
}
