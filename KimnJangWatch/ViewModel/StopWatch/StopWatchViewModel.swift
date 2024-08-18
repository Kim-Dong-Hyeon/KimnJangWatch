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
enum UDKeys: String {
  case startTime = "startTime"
  case elapsTime = "elapsTime"
  case timeStatus = "timeStatus"
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
    self.setupObservers()
    self.restoreState()
  }
  private func setupObservers() {
    NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
  }
  
  
  func saveCurrentState() {
    let defaults = UserDefaults.standard
    defaults.set(Date(),forKey: UDKeys.startTime.rawValue)
    defaults.set(elapsedTime,forKey: UDKeys.elapsTime.rawValue)
    defaults.set(self.watchStatus == .start ? "start" : "stop", forKey: UDKeys.timeStatus.rawValue)
  }
  func restoreState() {
    let defaults = UserDefaults.standard
    guard let savedTimeStatus = defaults.string(forKey: UDKeys.timeStatus.rawValue),
          let savedStartTime = defaults.object(forKey: UDKeys.startTime.rawValue)
            as? Date else { return }
    
    let savedElapsedTime = defaults.double(forKey: UDKeys.elapsTime.rawValue)
    elapsedTime = savedElapsedTime + Date().timeIntervalSince(savedStartTime)
    
    if savedTimeStatus == "stop" {
      watchStatus = .stop
      startTime = Date() - elapsedTime
      startTimer()
    }
    let timeString = formattedTime(from: elapsedTime)
    onTimeUpdate?(timeString)
  }
  func didTapStartButton() {
    switch self.watchStatus {
    case .start:
      self.watchStatus = .stop
      self.startTime = Date() - elapsedTime
      self.startTimer()
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
    self.lapcounts.removeAll()
    self.lapcount = 1
    self.onTimeUpdate?("00:00:00.00")
    clearSavedStatus()
  }
  
  private func startTimer() {
    self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    RunLoop.current.add(self.timer!, forMode: .common)
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
  private func clearSavedStatus() {
    let defaults = UserDefaults.standard
    defaults.removeObject(forKey: UDKeys.startTime.rawValue)
    defaults.removeObject(forKey: UDKeys.timeStatus.rawValue)
    defaults.removeObject(forKey: UDKeys.elapsTime.rawValue)
  }
}

extension StopWatchViewModel {
  @objc private func appWillEnterBackground() {
    saveCurrentState()
    if watchStatus == .stop {
      timer?.invalidate()
    }
  }
  @objc private func appWillEnterForeground() {
    restoreState()
  }
}
