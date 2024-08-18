//
//  NotificationManager.swift
//  KimnJangWatch
//
//  Created by 김동현 on 8/13/24.
//

import UserNotifications

/// 앱 내에서 로컬 알림을 관리하는 싱글톤 클래스입니다.
/// 알림을 예약, 취소, 삭제, 조회하는 기능을 제공합니다.
class NotificationManager {
  static let shared = NotificationManager()
  
  private init() {}
  
  /// 특정 시간에 알림을 예약합니다.
  /// - Parameters:
  ///   - date: 알림이 울릴 시간
  ///   - message: 알림의 내용
  ///   - identifier: 알림의 고유 식별자
  func scheduleNotification(at date: Date, with message: String, identifier: String) {
    let content = UNMutableNotificationContent()
    content.title = "Kim&Jang"
    content.body = message
    content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "hummus.mp3"))
    
    let triggerDate = Calendar.current.dateComponents(
      [.month,.day,.hour,.minute,.second],
      from: date
    )
    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
    
    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
  }
  
  /// 특정 식별자의 알림을 취소합니다.
  /// - Parameter identifier: 취소할 알림의 고유 식별자
  func cancelNotification(identifier: String) {
    UNUserNotificationCenter.current().removePendingNotificationRequests(
      withIdentifiers: [identifier]
    )
  }
  
  /// 모든 예약된 알림을 삭제합니다.
  func removeAllNotifications() {
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
  }
  
  /// 현재 예약된 알림 목록을 조회합니다.
  /// - Parameter completion: 예약된 알림 목록을 반환하는 클로저
  func getPendingNotifications(completion: @escaping ([UNNotificationRequest]) -> Void) {
    UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
      completion(requests)
    }
  }
}
