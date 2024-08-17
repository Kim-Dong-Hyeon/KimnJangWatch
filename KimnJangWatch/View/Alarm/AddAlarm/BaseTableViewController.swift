//
//  BaseTableView.swift
//  KimnJangWatch
//
//  Created by 김윤홍 on 8/17/24.
//

import UIKit

import SnapKit

class BaseTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  let tableView = UITableView(frame: .zero, style: .insetGrouped)
  var titles = [String]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupTableView()
    configureUI()
  }
  
  private func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    view.addSubview(tableView)
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    
    tableView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  func configureUI() {
    
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return titles.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = titles[indexPath.row]
    return cell
  }
}
