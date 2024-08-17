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
    print("New timer added with time: \(time)")
  }
  
  func startTimer(id: UUID) {
    guard let timer = getTimer(id: id), timer.isRunning.value else { return }
    timer.isRunning.accept(true)
    
    Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
      .take(until: { _ in
        timer.remainingTime.value <= 0
      })
      .subscribe(onNext: { [weak self] _ in
        guard let self else { return }
        let currentTime = timer.remainingTime.value - 1
        timer.remainingTime.accept(currentTime)
        if currentTime <= 0 {
          self.pauseTimer(id: id)
          self.endTimer.onNext(id)
        }
      }).disposed(by: disposeBag)
  }
  
  func pauseTimer(id: UUID) {
    guard let timer = getTimer(id: id) else { return }
    timer.isRunning.accept(false)
  }
  
  func cancelTimer(id: UUID) {
    guard let timer = getTimer(id: id) else { return }
    pauseTimer(id: id)
    timer.remainingTime.accept(0)
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
