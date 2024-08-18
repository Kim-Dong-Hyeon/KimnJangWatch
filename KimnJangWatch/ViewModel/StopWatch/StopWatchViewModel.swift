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
enum UDKeys: String, CaseIterable {
  case startTime = "startTime"
  case elapsTime = "elapsTime"
  case timeStatus = "timeStatus"
  case recordList = "recordList"
  case lapCounts = "lapCounts"
}
class StopWatchViewModel {
  private var timer: Timer?
  private var startTime = Date()
  private var lapcount = 1
  private var elapsedTime: TimeInterval = 0
  var watchStatus: WatchStatus = .start
  var lapcounts: [Int] = [] {
    didSet {
      onRecordListUpdate?()
    }
  }
  var recordList: [String] = [] {
    didSet {
      onRecordListUpdate?()
    }
  }
  var onTimeUpdate: ((String) -> Void)?
  var onRecordListUpdate: (() -> Void)?
  init() {
    self.setupObservers()
    self.restoreState()
  }
  deinit {//NotificationCenter를 통해 등록한 옵저버는 deinit 시에 반드시 해제해야 메모리 누수를 방지할 수 있습니다.
    NotificationCenter.default.removeObserver(self)
  }
  func didTapStartButton() {
    self.toggleWatchStatus()
  }
  func didTapLapButton() {
    let timeString = formattedTime(from: elapsedTime)
    self.recordList.append(timeString)
    self.lapcounts.append(lapcount)
    self.lapcount += 1
    saveCurrentState()
  }
  @objc func didTapResetButton() {
    self.performReset()
  }
  private func toggleWatchStatus() {
    switch self.watchStatus {
    case .start:
      self.startWatch()
    case .stop:
      self.stopWatch()
    }
  }
  private func startWatch() {
    self.watchStatus = .stop
    self.startTime = Date() - self.elapsedTime
    self.startTimer()
  }
  private func stopWatch() {
    self.watchStatus = .start
    timer?.invalidate()
    saveCurrentState()
  }
  private func performReset() {
    self.stopWatch()
    self.elapsedTime = 0
    self.recordList.removeAll()
    self.lapcounts.removeAll()
    self.lapcount = 1
    self.onTimeUpdate?("00:00:00.00")
    clearSavedStatus()
  }
}

extension StopWatchViewModel {
  private func startTimer() {
    self.timer?.invalidate()//중복타이머발생위험방지
    self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    if let timer = timer {
      RunLoop.current.add(timer, forMode: .common) }
  }
  @objc private func updateTime() {
    elapsedTime = Date().timeIntervalSince(startTime)
    let timeString = formattedTime(from: elapsedTime)
    onTimeUpdate?(timeString)
  }
  func formattedTime(from timeInterval: TimeInterval) -> String {//시간을 문자열로반환
    let hour = Int(timeInterval) / 3600
    let minutes = (Int(timeInterval) / 60) % 60
    let seconds = Int(timeInterval) % 60
    let milliseconds = Int(timeInterval * 100) % 100
    return String(format: "%02d:%02d:%02d.%02d", hour, minutes, seconds, milliseconds)
  }

}
//MARK: - Data Manager
extension StopWatchViewModel {
  private func saveCurrentState() {
    let defaults = UserDefaults.standard
    defaults.set(Date(),forKey: UDKeys.startTime.rawValue)
    defaults.set(elapsedTime,forKey: UDKeys.elapsTime.rawValue)
    defaults.set(self.watchStatus == .start ? "start" : "stop", forKey: UDKeys.timeStatus.rawValue)
    defaults.set(self.recordList, forKey: UDKeys.recordList.rawValue)
    defaults.set(self.lapcounts, forKey: UDKeys.lapCounts.rawValue)
  }
  private func restoreState() {
    let defaults = UserDefaults.standard
    guard let savedTimeStatus = defaults.string(forKey: UDKeys.timeStatus.rawValue),
          let savedStartTime = defaults.object(forKey: UDKeys.startTime.rawValue)
            as? Date else { return }
    let savedElapsedTime = defaults.double(forKey: UDKeys.elapsTime.rawValue)
    self.elapsedTime = savedElapsedTime
    self.recordList = defaults.stringArray(forKey: UDKeys.recordList.rawValue) ?? []
    self.lapcounts = defaults.array(forKey: UDKeys.lapCounts.rawValue) as? [Int] ?? []
    
    if savedTimeStatus == "stop" {
      let addtionalTime = Date().timeIntervalSince(savedStartTime)
      self.elapsedTime += addtionalTime
      self.startWatch()
    }
    else {
      self.watchStatus = .start
      self.updateTimeUI()
    }
    
  }
  private func updateLapTableView() {
    
  }
  private func updateTimeUI() {
    let timeString = formattedTime(from: self.elapsedTime)
    onTimeUpdate?(timeString)
  }
  private func clearSavedStatus() {
    let defaults = UserDefaults.standard
    UDKeys.allCases.forEach { defaults.removeObject(forKey: $0.rawValue) }
  }
}
//MARK: - NotificationCenter Observer Manager
extension StopWatchViewModel {
  private func setupObservers() {
    NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
  }
  @objc private func appWillEnterBackground() {
    saveCurrentState()
    stopWatch()
  }
  @objc private func appWillEnterForeground() {
    restoreState()
  }
}
