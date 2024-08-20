//
//  BaseTableViewController.swift
//  KimnJangWatch
//
//  Created by 김윤홍 on 8/17/24.
// titles cell 의 label등 모델로 옮기기 

import UIKit

import RxCocoa
import RxSwift
import SnapKit

class BaseTableViewController: UIViewController {
  
  let tableView = UITableView(frame: .zero, style: .insetGrouped)
  let disposeBag = DisposeBag()
  let addAlarmData = AddAlarm()
  var titles = [String]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
    configureUI()
    bind()
    navigationItem.leftBarButtonItem = backButton()
  }
  
  private func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    view.addSubview(tableView)
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    
    tableView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  func bind() {
    
    guard let left = navigationItem.leftBarButtonItem?.customView as? UIButton else { return }
    
    left.rx.tap.bind { [weak self] in
      guard let self = self else { return }
      saveData()
      self.navigationController?.popViewController(animated: true)
    }.disposed(by: disposeBag)
  }
  
  private func backButton() -> UIBarButtonItem {
    let button = UIButton()
    button.setTitle("뒤로", for: .normal)
    button.setTitleColor(UIColor.dangn, for: .normal)
    return UIBarButtonItem(customView: button)
  }
  
  func saveData() {
  }
  
  func configureUI() {
    
  }
}

extension BaseTableViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return titles.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    var content = cell.defaultContentConfiguration()
    content.text = self.titles[indexPath.row]
    cell.contentConfiguration = content
    return cell
  }
}
