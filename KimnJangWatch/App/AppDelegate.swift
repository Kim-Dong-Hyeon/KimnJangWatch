//
//  AppDelegate.swift
//  KimnJangWatch
//
//  Created by 김동현 on 8/12/24.
//

import CoreData
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    // 알림 권한 요청
    requestNotificationAuthorization()
    
    // 기본 윈도우 설정
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.rootViewController = TabBarController()
    window.makeKeyAndVisible()
    
    self.window = window
    
    // UNUserNotificationCenter의 delegate 설정
    UNUserNotificationCenter.current().delegate = self

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
  
  lazy var persistentContainer: NSPersistentContainer = {
    
    let container = NSPersistentContainer(name: "KimnJangWatch")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  // MARK: - Core Data Saving support
  
  func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
  
}

extension AppDelegate: UNUserNotificationCenterDelegate {
  // 앱이 foreground 상태일 때 알림을 처리하는 메서드
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions
    ) -> Void) {
    // 알림을 화면에 표시
    completionHandler([.banner, .list, .sound])
  }
}
