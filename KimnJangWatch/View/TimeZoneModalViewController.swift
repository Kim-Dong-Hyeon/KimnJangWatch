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
  
  let cities = Observable.just(TimeZone.knownTimeZoneIdentifiers)
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
    setLayout()
    setTableView()
    tableViewTapped()
  }
  
  func setTableView() {
    cities
      .bind(to: tableView.rx.items) { (tableView, row, element) in
        let cell = UITableViewCell()
        let country = TimeZone(identifier: element)?.localizedName(for: .shortGeneric, locale: Locale(identifier: "ko_KR")) ?? ""
        cell.textLabel?.text = country
        return cell
      }
      .disposed(by: disposeBag)
  }
  
  func tableViewTapped() {
    var cityString = ""
    tableView.rx.itemSelected
      .subscribe(onNext: { [weak self] indexPath in
        // tap한 cell 도시 WorlTimeVC로 넘기기
        self?.cities.compactMap { array in
          array.indices.contains(indexPath.row) ? array[indexPath.row] : nil
        }.subscribe(onNext: { city in
          cityString = city
        })
        .disposed(by: self!.disposeBag)
        print(cityString)
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
//      $0.height.equalTo(30)
    }
    
    tableView.snp.makeConstraints {
      $0.top.equalTo(searchBar.snp.bottom).offset(8)
      $0.left.right.bottom.equalToSuperview()
    }
  }
  
}
