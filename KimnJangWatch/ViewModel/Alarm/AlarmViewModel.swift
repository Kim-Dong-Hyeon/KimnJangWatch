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
  var times: [String] = UserDefaults.standard.array(forKey: "times") as? [String] ?? []
  let savedTimes: BehaviorSubject<[String]>
  
  init() {
    self.savedTimes = BehaviorSubject(value: times)
  }
  
  func addTime(_ time: String) {
    times = transform(timeList: times, newTime: time)
    UserDefaults.standard.set(times, forKey: "times")
    savedTimes.onNext(times)
  }
  
  //아직 구현 안되어있음
  func removeTime(at index: Int) {
    guard times.indices.contains(index) else { return }
    times.remove(at: index)
    UserDefaults.standard.set(times, forKey: "times")
    savedTimes.onNext(times)
  }
  
  func transform(timeList: [String], newTime: String) -> [String] {
    var newTimeList = timeList
    
    for (index, time) in newTimeList.enumerated() {
      let time1 = time.split(separator: ":")
      let time2 = newTime.split(separator: ":")
      
      if time1[0] > time2[0] || (time1[0] == time2[0] && time1[1] > time2[1]) {
        newTimeList.insert(newTime, at: index)
        return newTimeList
      } else if time1 == time2 {
        return newTimeList
      }
    }
    newTimeList.append(newTime)
    return newTimeList
  }
}
