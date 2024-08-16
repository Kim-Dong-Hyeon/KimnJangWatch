//
//  StopWatchViewModel.swift
//  KimnJangWatch
//
//  Created by bloom on 8/13/24.
//

import Foundation
import UIKit

enum WatchStatus {
  case start
  case stop
}
enum UserDefaultsKeys: String {
  case startTime = "savedStartTime"
  case elapsTime = "savedElapsTime"
}

class StopWatchViewModel {
  var watchStatus: WatchStatus = .start
  var timer: Timer?
  var startTime = Date()
  var lapcounts: [Int] = []
  var lapcount = 1
///화면이 꺼지거나 앱이 꺼졌을때 시간을 담을 변수
  var elapsedTime: TimeInterval = 0
  var recordList: [String] = []
  var onTimeUpdate: ((String) -> Void)?
  
  init() {
    NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
  }
  
  func didTapStartButton() {
    switch self.watchStatus {
    case .start:
      self.watchStatus = .stop
      startTime = Date() - elapsedTime
      self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    case .stop:
      self.watchStatus = .start
      timer?.invalidate()
    }
  }
  @objc func didTapLapButton() {//랩추가버튼탭
    let timeString = formattedTime(from: elapsedTime)
    self.recordList.append(timeString)
    self.lapcounts.append(lapcount)
    self.lapcount += 1
  }
  @objc func didTapResetButton() {//리셋버튼탭
    self.timer?.invalidate()
    self.watchStatus = .start
    self.elapsedTime = 0
    self.recordList.removeAll()
    self.onTimeUpdate?("00:00:00.00")
    self.lapcounts.removeAll()
    self.lapcount = 1
    UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.startTime.rawValue)
  }


 
}
extension StopWatchViewModel {
  @objc private func updateTime() {
    elapsedTime = Date().timeIntervalSince(startTime)
    let timeString = formattedTime(from: elapsedTime)
    onTimeUpdate?(timeString)
  }
  private func formattedTime(from timeInterval: TimeInterval) -> String {//시간을 문자열로반환
    let hour = Int(timeInterval) / 3600
    let minutes = (Int(timeInterval) / 60) % 60
    let seconds = Int(timeInterval) % 60
    let milliseconds = Int(timeInterval * 100) % 100
    return String(format: "%02d:%02d:%02d.%02d", hour, minutes, seconds, milliseconds)
  }
}

extension StopWatchViewModel {
///앱이 백그라운드로 전환될때 현재시간을 저장
  @objc private func appWillEnterBackground() {
    UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.startTime.rawValue)
    UserDefaults.standard.set(elapsedTime, forKey: UserDefaultsKeys.elapsTime.rawValue)
    if watchStatus == .stop {
      timer?.invalidate()
    }
  }
///앱으로 다시 돌아왔을때 시간을 추가해서 타이머의 시간을 변경함
  @objc private func appWillEnterForeground() {
    guard let savedStartTime = UserDefaults.standard.object(forKey: UserDefaultsKeys.startTime.rawValue) as? Date else { return }
    let savedElapsedTime = UserDefaults.standard.double(forKey: UserDefaultsKeys.elapsTime.rawValue)
    self.elapsedTime = savedElapsedTime + Date().timeIntervalSince(savedStartTime)
    if watchStatus == .stop {
      startTime = Date() - elapsedTime
      timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
  }
  
}
