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
  var times: [String: [String]] = UserDefaults.standard.dictionary(forKey: "times") as? [String: [String]] ?? [:]
  let savedTimes: BehaviorSubject<[String : [String]]>
  
  init() {
    self.savedTimes = BehaviorSubject(value: times)
  }
  
  func addTime(day: [String], time: String) {
    times[time] = day
    saveTimes()
    savedTimes.onNext(times)
  }
  
  //아직 구현 안되어있음
  func removeTime(time: String) {
    times.removeValue(forKey: time)
    saveTimes()
    savedTimes.onNext(times)
  }
  
  private func saveTimes() {
    UserDefaults.standard.set(times, forKey: "times")
  }
  
//  func transform(timeList: [String]) -> [String] {
//    var newTimeList = timeList
//    
//    for (index, time) in newTimeList.enumerated() {
//      let time1 = time.split(separator: ":")
//      let time2 = time.split(separator: ":")
//      
//      if time1[0] > time2[0] || (time1[0] == time2[0] && time1[1] > time2[1]) {
//        newTimeList.insert((day: newDay, time: newTime), at: index)
//        return newTimeList
//      } else if time1 == time2 && time.day == newDay {
//        return newTimeList
//      }
//    }
//    newTimeList.append((day: newDay, time: newTime))
//    return newTimeList
//  }
}
