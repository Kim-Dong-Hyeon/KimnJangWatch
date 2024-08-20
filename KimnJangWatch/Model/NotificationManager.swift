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
  ///   - date: 알림이 울릴 날짜와 시간
  ///   - message: 알림의 내용
  ///   - identifier: 알림의 고유 식별자
  ///   - repeats: 알람이 반복될 요일 배열 (1: 일요일, 2: 월요일, ..., 7: 토요일)
  ///   - snooze: 다시 알림 기능 활성화 여부
  ///   - soundName: 알림음 이름
  func scheduleNotification(
    at date: Date,
    with message: String,
    identifier: String,
    repeats: [Int] = [],
    snooze: Bool = false,
    soundName: String = "default"
  ) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let _ = dateFormatter.string(from: date)
    
    let content = UNMutableNotificationContent()
    content.title = "Kim&Jang"
    content.body = message
    if soundName != "default" {
      content.sound = UNNotificationSound(
        named: UNNotificationSoundName(rawValue: "\(soundName).mp3")
      )
    } else {
      content.sound = UNNotificationSound.default
    }
    
    let currentDate = Date()
    var finalDate = date
    
    // 알림 시간이 과거인 경우, 알림 시간을 다음 날로 설정
    if finalDate < currentDate {
      finalDate = Calendar.current.date(byAdding: .day, value: 1, to: finalDate)!
    }
    
    if repeats.isEmpty {
      let triggerDate = Calendar.current.dateComponents(
        [.year, .month, .day, .hour, .minute, .second],
        from: finalDate
      )
      let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
      
      let request = UNNotificationRequest(
        identifier: identifier,
        content: content,
        trigger: trigger
      )
      UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
      
      // 다시 알림 (snooze) 설정이 true라면, 9분 뒤에 추가 알림을 생성
      if snooze {
        let snoozeDate = Calendar.current.date(byAdding: .minute, value: 9, to: finalDate)!
        let snoozeIdentifier = identifier + "_snooze"
        let snoozeTriggerDate = Calendar.current.dateComponents(
          [.year, .month, .day, .hour, .minute, .second],
          from: snoozeDate
        )
        let snoozeTrigger = UNCalendarNotificationTrigger(
          dateMatching: snoozeTriggerDate,
          repeats: false
        )
        
        let snoozeRequest = UNNotificationRequest(
          identifier: snoozeIdentifier,
          content: content,
          trigger: snoozeTrigger
        )
        UNUserNotificationCenter.current().add(snoozeRequest, withCompletionHandler: nil)
      }
    } else {
      for weekday in repeats {
        var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: finalDate)
        dateComponents.weekday = weekday + 1
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let weekdayIdentifier = "\(identifier)_\(weekday + 1)"
        
        let request = UNNotificationRequest(
          identifier: weekdayIdentifier,
          content: content,
          trigger: trigger
        )
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        // 반복 알림에서도 다시 알림 (snooze) 설정이 true라면, 9분 뒤에 추가 알림을 생성
        if snooze {
          var snoozeComponents = dateComponents
          snoozeComponents.minute! += 9
          let snoozeIdentifier = "\(weekdayIdentifier)_snooze"
          
          let snoozeTrigger = UNCalendarNotificationTrigger(
            dateMatching: snoozeComponents,
            repeats: true
          )
          let snoozeRequest = UNNotificationRequest(
            identifier: snoozeIdentifier,
            content: content,
            trigger: snoozeTrigger
          )
          UNUserNotificationCenter.current().add(snoozeRequest, withCompletionHandler: nil)
        }
      }
    }
  }
  
  /// 특정 식별자의 알림을 취소합니다.
  /// - Parameter identifier: 취소할 알림의 고유 식별자
  func cancelNotification(identifier: String) {
    let center = UNUserNotificationCenter.current()
    
    center.getPendingNotificationRequests { requests in
      let identifiersToCancel = requests
        .filter { $0.identifier.hasPrefix(identifier) }.map { $0.identifier }
      center.removePendingNotificationRequests(withIdentifiers: identifiersToCancel)
    }
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
