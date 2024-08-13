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
    // Do any additional setup after loading the view.
    
    let testNotificationVC = UINavigationController(rootViewController: TestNotificationViewController())
    
    testNotificationVC.tabBarItem = UITabBarItem(title: "알림 Test", image: UIImage(systemName: "globe"), selectedImage: UIImage(systemName: "globe"))
    
    self.setViewControllers([testNotificationVC], animated: true)
    
  }
  
  
}

