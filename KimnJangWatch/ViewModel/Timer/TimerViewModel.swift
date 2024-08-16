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
  let remainingTime = BehaviorRelay<TimeInterval>(value: 0)
  let isRunnning =  BehaviorRelay<Bool>(value: false)
  let endTimer = PublishSubject<Void>()
  
  private var timer: Observable<Int>?
  private var backgroundEntryTime = BehaviorRelay<Date?>(value: nil)
  private var disposeBag = DisposeBag()
  
  init() {
    manageTimer()
  }
  
  func manageTimer() {
    let enterBackGround = NotificationCenter.default.rx.notification(UIApplication.didEnterBackgroundNotification)
    let enterForeGround = NotificationCenter.default.rx.notification(UIApplication.willEnterForegroundNotification)
    
    enterBackGround
      .subscribe(onNext: { [weak self] _ in
        self?.saveTime()
      }).disposed(by: disposeBag)
    
    enterForeGround
      .subscribe(onNext: { [ weak self] _ in
        self?.loadTime()
      }).disposed(by: disposeBag)
  }
  
  func setTimer(time: TimeInterval) {
    remainingTime.accept(time)
  }
  
  func startTimer() {
    guard !isRunnning.value else { return }
    isRunnning.accept(true)
    
    timer = Observable<Int>
      .interval(.seconds(1), scheduler: MainScheduler.instance)
      .take(until: { [weak self] _ in
        return self?.remainingTime.value ?? 0 <= 0
      })
    
    timer?
      .subscribe(onNext: { [weak self] _ in
        guard let self else { return }
        let currentTime = self.remainingTime.value - 1
        self.remainingTime.accept(currentTime)
        if currentTime <= 0 {
          self.pauseTimer()
          self.endTimer.onNext(())
        }
      }).disposed(by: disposeBag)
  }
  
  func pauseTimer() {
    isRunnning.accept(false)
  }
  
  private func saveTime() {
    backgroundEntryTime.accept(Date())
  }
  
  private func loadTime() {
    guard let entryTime = backgroundEntryTime.value else { return }
    let passedTime = Date().timeIntervalSince(entryTime)
    let newTime = max((remainingTime.value - passedTime), 0)
    
    remainingTime.accept(newTime)
    
    if isRunnning.value && newTime > 0 {
      startTimer()
    } else {
      pauseTimer()
    }
  }
}
