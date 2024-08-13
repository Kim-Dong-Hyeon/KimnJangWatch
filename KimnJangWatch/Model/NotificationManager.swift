//
//  NotificationManager.swift
//  KimnJangWatch
//
//  Created by 김동현 on 8/13/24.
//

import UserNotifications

class NotificationManager {
  static let shared = NotificationManager()
  
  private init() {}
  
  func scheduleNotification(at date: Date, with message: String) {
    let content = UNMutableNotificationContent()
    content.title = "Kim&Jang"
    content.body = message
//    content.sound = UNNotificationSound.default
    content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "hummus.mp3"))
    
    let triggerDate = Calendar.current.dateComponents([.month,.day,.hour,.minute,.second], from: date)
    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
    
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
  }
}
