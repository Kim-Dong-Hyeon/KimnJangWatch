//
//  StopWatchController.swift
//  KimnJangWatch
//
//  Created by bloom on 8/12/24.
//

import UIKit

final class StopWatchController: UIViewController {
  lazy var resetButton = {
    let x = UIButton()
    x.setTitle("랩", for: .normal)
    x.setTitleColor(.red, for: .normal)
    x.layer.cornerRadius = 10
    x.backgroundColor = UIColor.lightGray
    
    return x
  }()
  lazy var startButton = {
    let x = UIButton()
    x.setTitle("시작", for: .normal)
    x.setTitleColor(.green, for: .normal)
    x.layer.cornerRadius = 10
    x.backgroundColor = UIColor.lightGray
    return x
  }()
  
  
  
  let timeLabCollectionView = UICollectionView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    
    
  }
  
}
extension StopWatchController {
  @objc func transformResetButton(){
    
  }
  @objc func transformStartButton(){
    
  }
  
  
}

extension StopWatchController: UITableViewDelegate,UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    <#code#>
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    <#code#>
  }
  
  
}

final class LabViewCell: UITableViewCell {
  
}

