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

  func sortTimes(_ time1: String, _ time2: String) -> Bool {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    
    guard let date1 = dateFormatter.date(from: time1),
          let date2 = dateFormatter.date(from: time2) else {
      return false
    }
    return date1 < date2
  }
  
  private func saveTimes() {
    UserDefaults.standard.set(times, forKey: "times")
  }
}
