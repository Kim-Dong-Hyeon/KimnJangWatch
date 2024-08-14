//
//  AlarmViewModel.swift
//  KimnJangWatch
//
//  Created by 김윤홍 on 8/13/24.
//

import UIKit

import RxSwift

class AlarmViewModel {
  var times: [String] = UserDefaults.standard.array(forKey: "times") as? [String] ?? []
  let savedTimes: BehaviorSubject<[String]>
  
  init() {
    self.savedTimes = BehaviorSubject(value: times)
  }
}
