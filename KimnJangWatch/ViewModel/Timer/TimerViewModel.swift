//
//  TimerViewModel.swift
//  KimnJangWatch
//
//  Created by 김승희 on 8/13/24.
//

import UIKit

import RxCocoa
import RxSwift

class TimerViewModel {
  static let shared = TimerViewModel()
  
  var timers = BehaviorRelay<[TimerModel]>(value: [])
  private var timerSubscription = [UUID:Disposable]()
  private var backgroundEntryTime = BehaviorRelay<Date?>(value: nil)
  private var disposeBag = DisposeBag()
  
  // MARK: 타이머 상태 관리
  func getTimer(id: UUID) -> TimerModel? {
    return timers.value.first(where: { $0.id == id })
  }
  
  func setNewTimer(time: TimeInterval) {
    let newTimer = TimerModel(id: UUID(),
                              remainingTime: BehaviorRelay<TimeInterval>(value: time),
                              isRunning: BehaviorRelay<Bool>(value: true))
    timers.accept(timers.value + [newTimer])
    startTimer(id: newTimer.id)
  }
  
  func startTimer(id: UUID) {
    guard let timer = getTimer(id: id), timer.isRunning.value else { return }
    
    let endTime = Date().addingTimeInterval(timer.remainingTime.value)
    notification(id: id, endTime: endTime)
    
    if let previousSubscription = timerSubscription[id] {
      previousSubscription.dispose()
      timerSubscription.removeValue(forKey: id)
    }
    
    let subscription = Observable<Int>.interval(.milliseconds(100),
                                                scheduler: MainScheduler.instance)
      .subscribe(onNext: { [weak self] _ in
        guard let self = self else { return }
        let currentTime = max(timer.remainingTime.value - 0.1, 0)
        timer.remainingTime.accept(currentTime)
        
        if currentTime <= 0 {
          self.endTimer(id: id)
          self.timerSubscription[id]?.dispose()
          self.timerSubscription.removeValue(forKey: id)
        }
      })
    timerSubscription[id] = subscription
  }
  
  func pauseTimer(id: UUID) {
    guard let timer = getTimer(id: id) else { return }
    timer.isRunning.accept(false)
    
    let remainingTime = timer.remainingTime.value
    NotificationManager.shared.cancelNotification(identifier: id.uuidString)
    timerSubscription[id]?.dispose()
    timerSubscription.removeValue(forKey: id)
  }
  
  func resumeTimer(id: UUID) {
    guard let timer = getTimer(id: id) else { return }
    let remainingTime = timer.remainingTime.value
    timer.isRunning.accept(true)
    
    let newEndTime = Date().addingTimeInterval(remainingTime)
    notification(id: id, endTime: newEndTime)
    
    startTimer(id: timer.id)
  }
  
  func cancelTimer(id: UUID) {
    guard let timer = getTimer(id: id) else { return }
    pauseTimer(id: id)
    timer.remainingTime.accept(0)
    
    NotificationManager.shared.cancelNotification(identifier: id.uuidString)
    removeTimer(id: id)
  }
  
  func endTimer(id: UUID) {
    removeTimer(id: id)
  }
  
  func removeTimer(id: UUID) {
    timers.accept(timers.value.filter { $0.id != id } )
  }

  // MARK: 앱 상태 관리 - viewController에서 호출 필요
  func manageTimerState() {
    let enterBackground = NotificationCenter.default
      .rx.notification(UIApplication.didEnterBackgroundNotification)
    let enterForeground = NotificationCenter.default
      .rx.notification(UIApplication.willEnterForegroundNotification)
    
    enterBackground
      .subscribe(onNext: { [weak self] _ in
        self?.saveTimes()
      }).disposed(by: disposeBag)
    
    enterForeground
      .subscribe(onNext: { [weak self] _ in
        self?.loadTimes()
      }).disposed(by: disposeBag)
  }

  private func saveTimes() {
    backgroundEntryTime.accept(Date())
  }
  
  private func loadTimes() {
    guard let entryTime = backgroundEntryTime.value else { return }
    let passedTime = Date().timeIntervalSince(entryTime)
    
    timers.value.forEach { timer in
      if timer.isRunning.value {
        let newTime = max((timer.remainingTime.value - passedTime), 0)
        timer.remainingTime.accept(newTime)
        
        if newTime > 0 {
          startTimer(id: timer.id)
        } else {
          pauseTimer(id: timer.id)
        }
      }
    }
  }

  // MARK: 시간 format
  func formatTime(time: TimeInterval) -> String {
    let hours = Int(time) / 3600
    let minutes = (Int(time) / 60) % 60
    let seconds = Int(time) % 60
    
    if hours > 0 {
      return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    } else {
      return String(format: "%02d:%02d", minutes, seconds)
    }
  }

  // MARK: notification
  func notification(id: UUID, endTime: Date) {
    let message = "타이머가 종료되었습니다."
    NotificationManager.shared.scheduleNotification(
      at: endTime,
      with: message,
      identifier: id.uuidString,
      repeats: [],
      snooze: false // 타이머에서는 다시 알림을 비활성화
    )
  }
}
