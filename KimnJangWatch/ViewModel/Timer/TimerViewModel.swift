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
  let endTimer = PublishSubject<UUID>()
  private var backgroundEntryTime = BehaviorRelay<Date?>(value: nil)
  private var disposeBag = DisposeBag()
    
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
  
  func getTimer(id: UUID) -> TimerModel? {
    return timers.value.first(where: { $0.id == id })
  }
  
  func setNewTimer(time: TimeInterval) {
    let newTimer = TimerModel(id: UUID(),
                              remainingTime: BehaviorRelay<TimeInterval>(value: time),
                              isRunning: BehaviorRelay<Bool>(value: true))
    timers.accept(timers.value + [newTimer])
    startTimer(id: newTimer.id)
    print("New timer added with time: \(time)")
  }
  
  func startTimer(id: UUID) {
    guard var timer = getTimer(id: id), timer.isRunning.value else { return }
    timer.isRunning.accept(true)
    timer.disposeBag = DisposeBag()
    
    let endTime = Date().addingTimeInterval(timer.remainingTime.value)
    notification(id: id, endTime: endTime)
    
    Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
      .take(until: { _ in
        timer.remainingTime.value <= 0
      })
      .subscribe(onNext: { [weak self] _ in
        guard let self else { return }
        let currentTime = timer.remainingTime.value - 1
        timer.remainingTime.accept(currentTime)
        if currentTime <= 0 {
          self.endTimer(id: id)
        }
      }).disposed(by: timer.disposeBag!)
  }
  
  func pauseTimer(id: UUID) {
    guard var timer = getTimer(id: id) else { return }
    timer.isRunning.accept(false)
    timer.disposeBag = nil
    
    // 알림취소 메서드 추가 예정
  }
  
  func cancelTimer(id: UUID) {
    guard let timer = getTimer(id: id) else { return }
    pauseTimer(id: id)
    timer.remainingTime.accept(0)
    removeTimer(id: id)
  }
  
  func endTimer(id: UUID) {
    removeTimer(id: id)
  }
  
  func notification(id: UUID, endTime: Date) {
    let message = "타이머가 종료되었습니다."
    NotificationManager.shared.scheduleNotification(at: endTime, with: message)
    print("Notification scheduled for timer with ID: \(id) at \(endTime)")
  }
  
  func removeTimer(id: UUID) {
    timers.accept(timers.value.filter { $0.id != id })
  }
  
  private func saveTimes() {
    backgroundEntryTime.accept(Date())
  }
  
  private func loadTimes() {
    guard let entryTime = backgroundEntryTime.value else { return }
    let passedTime = Date().timeIntervalSince(entryTime)
    
    timers.value.forEach { timer in
      let newTime = max((timer.remainingTime.value - passedTime), 0)
      timer.remainingTime.accept(newTime)
      
      if timer.isRunning.value && newTime > 0 {
        startTimer(id: timer.id)
      } else {
        pauseTimer(id: timer.id)
      }
    }
  }
}
