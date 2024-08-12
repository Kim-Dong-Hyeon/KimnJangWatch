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
    
    worldTimeVC.tabBarItem = UITabBarItem(title: "세계 시간", image: UIImage(systemName: "globe"), selectedImage: UIImage(systemName: "globe"))
    
    self.setViewControllers([worldTimeVC], animated: true)
  }


}

