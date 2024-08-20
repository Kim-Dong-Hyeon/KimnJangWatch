//
//  StopWatchViewModel.swift
//  KimnJangWatch
//
//  Created by bloom on 8/13/24.
//
import Foundation

enum WatchStatus {
  case start
  case pause
  case stop
}

class StopWatchViewModel {
  var watchStatus: WatchStatus = .stop
  var stopWatchTimer: Timer?
  var lapTimer: Timer?
  
  var startTime: Date?
  var elapsedTime: TimeInterval = 0
  var lapStartTime: Date?
  var lapElapsedTime: TimeInterval = 0
  var recordList: [String] = []
  var lapCounts: [Int] = []
  var lapCount: Int = 0
  var onTimeUpdate: ((String) -> Void)?
  var onLapUpdate: ((String) -> Void)?
  
  func didTapStartStopButton() {
    switch self.watchStatus {
    case .stop://초기에 시작버튼을 누를경우
      self.startTimer()
    case .start://시작상태에서 정지버튼을 누를경우
      self.stopTimer()
    case .pause://정지상태에서 시작버튼을 누를경우
      self.restartTimer()
    }
  }
  
  func didTapLapResetButton() {
    switch self.watchStatus {
    case .stop: break
    case .start: //타이머가 구동되는동안 랩버튼을 누를경우
      self.saveLapRecord()
    case .pause: //타이머가 멈춰있는동안 재시작을 누를경우
      self.resetAllData()
    }
  }
  
  private func startTimer() {
    self.watchStatus = .start
    self.startTime = Date()
    self.stopWatchTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
    RunLoop.current.add(self.stopWatchTimer!, forMode: .common)
    self.lapStartTime = Date()
    self.startLapTimer()
  }
  
  private func stopTimer() {
    self.watchStatus = .pause
    self.stopWatchTimer?.invalidate()
    self.lapTimer?.invalidate()
    self.stopWatchTimer = nil
    self.lapTimer = nil
  }
  
  private func restartTimer() {
    self.watchStatus = .start
    self.startTime = Date().addingTimeInterval(-self.elapsedTime)
    self.stopWatchTimer = Timer(timeInterval: 0.01, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
    RunLoop.current.add(self.stopWatchTimer!, forMode: .common)
    self.lapStartTime = Date().addingTimeInterval(-self.lapElapsedTime)
    self.startLapTimer()
  }
  
  private func saveLapRecord() {
    if let lapStartTime = self.lapStartTime {
      self.lapElapsedTime = Date().timeIntervalSince(lapStartTime)
      let lapTimeString = timeToString(from: self.lapElapsedTime)
      self.recordList.insert(lapTimeString, at: 0)
      self.lapCount += 1
      self.lapCounts.insert(lapCount, at: 0)
      self.onLapUpdate?(lapTimeString)
    }
    self.lapStartTime = Date()
    self.startLapTimer()
  }
  
  private func startLapTimer() {
    self.lapTimer?.invalidate()
    self.lapTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.updateLapTime), userInfo: nil, repeats: true)
    RunLoop.current.add(self.lapTimer!, forMode: .common)
  }
  
  private func resetAllData() {
    self.stopTimer()
    self.watchStatus = .stop
    self.elapsedTime = 0
    self.lapElapsedTime = 0
    self.recordList.removeAll()
    self.lapCounts.removeAll()
    self.lapCount = 0
    self.onTimeUpdate?("00:00.00")
    self.onLapUpdate?("00:00.00")
  }
  
  @objc func updateTime() {
    guard let startTime = self.startTime else { return }
    self.elapsedTime = Date().timeIntervalSince(startTime)
    let timeString = timeToString(from: self.elapsedTime)
    self.onTimeUpdate?(timeString)
  }
  
  @objc func updateLapTime() {
    guard let lapStartTime = self.lapStartTime else { return }
    self.lapElapsedTime = Date().timeIntervalSince(lapStartTime)
    let lapTimeString = timeToString(from: self.lapElapsedTime)
    self.onLapUpdate?(lapTimeString)
  }
  
  private func timeToString(from timeInterval: TimeInterval) -> String {
    let minutes = Int(timeInterval) / 60 % 60
    let seconds = Int(timeInterval) % 60
    let milliseconds = Int(timeInterval * 100) % 100
    return String(format: "%02d:%02d.%02d", minutes, seconds, milliseconds)
  }
  
}
