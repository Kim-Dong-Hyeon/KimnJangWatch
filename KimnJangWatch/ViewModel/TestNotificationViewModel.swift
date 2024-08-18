//
//  TestNotificationViewModel.swift
//  KimnJangWatch
//
//  Created by 김동현 on 8/17/24.
//

import Foundation
import UserNotifications

/// 알림 관련 로직을 관리하고, View와 Model 사이의 데이터 흐름을 관리합니다.
class TestNotificationViewModel {
  
  private var pauseTime: TimeInterval?
  private var originalTriggerDate: Date?
  private var notificationIdentifier: String?
  
  /// 5초 후 알림을 예약하고, 예약된 알림의 식별자를 반환합니다.
  /// - Parameter completion: 예약된 알림의 식별자를 반환하는 클로저
  func triggerNotification(completion: @escaping (String) -> Void) {
    let date = Date().addingTimeInterval(5) // 5초 후 알림 트리거
    let identifier = UUID().uuidString // 고유 식별자 생성
    notificationIdentifier = identifier
    originalTriggerDate = date
    NotificationManager.shared.scheduleNotification(
      at: date,
      with: "test 알림입니다",
      identifier: identifier
    )
    completion(identifier)
  }
  
  /// 현재 예약된 알림을 일시정지하고, 남은 시간을 반환합니다.
  /// - Returns: 남은 시간 (초 단위)
  func pauseNotification() -> TimeInterval? {
    guard let identifier = notificationIdentifier,
          let triggerDate = originalTriggerDate else { return nil }
    
    // 알림 취소
    NotificationManager.shared.cancelNotification(identifier: identifier)
    
    // 남은 시간 계산
    pauseTime = triggerDate.timeIntervalSinceNow
    print("Paused with \(pauseTime!) seconds remaining")
    
    return pauseTime
  }
  
  /// 일시정지된 알림을 재개하고, 예약된 알림의 식별자를 반환합니다.
  /// - Returns: 재개된 알림의 식별자
  func resumeNotification() -> String? {
    guard let remainingTime = pauseTime,
          let identifier = notificationIdentifier else { return nil }
    
    let newDate = Date().addingTimeInterval(remainingTime)
    NotificationManager.shared.scheduleNotification(
      at: newDate,
      with: "test 알림입니다",
      identifier: identifier
    )
    print("Resumed with \(remainingTime) seconds remaining")
    
    return identifier
  }
  
  /// 현재 예약된 모든 알림 목록을 조회합니다.
  /// - Parameter completion: 예약된 알림 목록을 반환하는 클로저
  func showPendingNotifications(completion: @escaping ([UNNotificationRequest]) -> Void) {
    NotificationManager.shared.getPendingNotifications { requests in
      completion(requests)
    }
  }
  
  /// 모든 예약된 알림을 삭제하고, 삭제 완료 후 클로저를 실행합니다.
  /// - Parameter completion: 알림 삭제 후 실행할 클로저
  func removeAllNotifications(completion: @escaping () -> Void) {
    NotificationManager.shared.removeAllNotifications()
    completion()
  }
}
