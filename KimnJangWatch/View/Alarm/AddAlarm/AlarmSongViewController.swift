//
//  AlarmSongViewController.swift
//  KimnJangWatch
//
//  Created by 김윤홍 on 8/17/24.
//

import UIKit

class AlarmSongViewController: BaseTableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    titles = ["a", "b", "c", "d", "E", "F", "G", "h"]
  }
  
  override func configureUI() {
    navigationItem.title = "사운드"
  }
}
