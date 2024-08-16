//
//  TabBarController.swift
//  KimnJangWatch
//
//  Created by 김동현 on 8/12/24.
//

import UIKit

class TabBarController: UITabBarController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tabBar.tintColor = .dangn
    
    let worldTimeVC = UINavigationController(rootViewController: WorldTimeViewController())
    worldTimeVC.tabBarItem = UITabBarItem(title: "세계 시간", image: UIImage(systemName: "globe"), tag: 0)
    
    let alarmVC = UINavigationController(rootViewController: AlarmViewController())
    alarmVC.tabBarItem = UITabBarItem(title: "알람", image: UIImage(systemName: "alarm"), tag: 1)
    
    let stopWatchVC = UINavigationController(rootViewController: StopWatchController())
    stopWatchVC.tabBarItem = UITabBarItem(title: "스톱워치", image: UIImage(systemName: "stopwatch"), tag: 2)
    
    let timerVC = UINavigationController(rootViewController: TimerViewController())
    timerVC.tabBarItem = UITabBarItem(title: "타이머", image: UIImage(systemName: "timer"), tag: 3)
    
    let testNotificationVC = UINavigationController(rootViewController: TestNotificationViewController())
    testNotificationVC.tabBarItem = UITabBarItem(title: "알림 Test", image: UIImage(systemName: "globe"), tag: 4)
    
    self.setViewControllers([worldTimeVC, alarmVC, stopWatchVC, timerVC, testNotificationVC], animated: true)
    // Do any additional setup after loading the view.
    
  }
  
}
