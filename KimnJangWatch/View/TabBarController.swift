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
    
    let worldTimeVC = UINavigationController(rootViewController: WorldTimeViewController())
    worldTimeVC.tabBarItem = UITabBarItem(title: "세계 시간", image: UIImage(systemName: "globe"), tag: 0)
    
    let stopWatchController = UINavigationController(rootViewController: StopWatchController())
    stopWatchController.tabBarItem = UITabBarItem(title: "스톱워치", image: UIImage(systemName: "stopwatch"), tag: 1)
    
    self.setViewControllers([worldTimeVC, stopWatchController], animated: true)
    // Do any additional setup after loading the view.
  }
  


}

