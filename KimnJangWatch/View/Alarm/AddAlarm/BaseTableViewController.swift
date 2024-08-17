//
//  BaseTableView.swift
//  KimnJangWatch
//
//  Created by 김윤홍 on 8/17/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

class BaseTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  private let tableView = UITableView(frame: .zero, style: .insetGrouped)
  private let disposeBag = DisposeBag()
  var titles = [String]()
  var checkedCell = BehaviorRelay<[IndexPath]>(value: [])
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
    configureUI()
    bind()
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
  
  private func bind() {
      tableView.rx.itemSelected
        .subscribe(onNext: { [weak self] indexPath in
          guard let self = self else { return }
    
          var checkedCells = self.checkedCell.value
          
          if checkedCells.contains(indexPath) {
            if let cell = self.tableView.cellForRow(at: indexPath) {
              cell.accessoryView = nil
            }
            checkedCells.removeAll(where: { $0 == indexPath })
          } else {
            if let cell = self.tableView.cellForRow(at: indexPath) {
              let checkmarkImage = UIImage(systemName: "checkmark")?.withRenderingMode(.alwaysTemplate)
              let checkmarkImageView = UIImageView(image: checkmarkImage)
              checkmarkImageView.tintColor = .dangn
              cell.accessoryView = checkmarkImageView
            }
            checkedCells.append(indexPath)
          }
          self.checkedCell.accept(checkedCells)
        })
        .disposed(by: disposeBag)
    }
  
  func configureUI() {
    
  }
  
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
