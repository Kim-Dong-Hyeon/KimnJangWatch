//
//  AlarmViewModel.swift
//  KimnJangWatch
//
//  Created by 김윤홍 on 8/13/24.
//
//Model과 ViewModel분리

import UIKit

import RxCocoa
import RxSwift

class AlarmViewModel {
  var times: [String: [Int]] = UserDefaults.standard.dictionary(forKey: "times") as? [String: [Int]] ?? [:]
  let savedTimes: BehaviorSubject<[String : [Int]]>
  
  init() {
    self.savedTimes = BehaviorSubject(value: times)
  }
  
  func addTime(day: [Int], time: String) {
    print(day, time)
    times[time] = day
    saveTimes()
    print("저장된 데이터: \(times)")
    savedTimes.onNext(times)
  }
  
  func removeTime(time: String) {
    times.removeValue(forKey: time)
    saveTimes()
    savedTimes.onNext(times)
  }
  
  private func saveTimes() {
    UserDefaults.standard.set(times, forKey: "times")
  }
}
