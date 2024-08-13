//
//  TabBarController.swift
//  Kim&JangWatch
//
//  Created by 김동현 on 8/12/24.
//

import UIKit

class TabBarController: UITabBarController {

  override func viewDidLoad() {
    super.viewDidLoad()
    let stopWatchController = UINavigationController(rootViewController: StopWatchController())
    stopWatchController.tabBarItem = UITabBarItem(title: "스톱워치", image: UIImage(systemName: "stopwatch"), tag: 0)
    self.viewControllers = [stopWatchController]
    // Do any additional setup after loading the view.
  }
  


}

