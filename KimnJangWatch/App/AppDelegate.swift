//
//  AppDelegate.swift
//  Kim&JangWatch
//
//  Created by 김동현 on 8/12/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    // 알림 권한 요청
    requestNotificationAuthorization()
    
    // 기본 윈도우 설정
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.rootViewController = TabBarController()
    window.makeKeyAndVisible()
    
    self.window = window
    
    return true
  }
  
  private func requestNotificationAuthorization() {
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
      if let error = error {
        print("Authorization Error: \(error.localizedDescription)")
      }
    }
  }
  
}

