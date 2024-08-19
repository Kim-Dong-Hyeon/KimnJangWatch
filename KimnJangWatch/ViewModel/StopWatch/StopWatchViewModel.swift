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
//타이머 관련 변수
  var watchStatus: WatchStatus = .stop
  var stopWatchTimer: Timer?
  var lapTimer: Timer?
  
//시간관련 변수
  var startTime: Date?
  var elapsedTime: TimeInterval = 0
  var lapStartTime: Date?
  var lapElapsedTime: TimeInterval = 0
//기록관련 변수
  var recordList: [String] = []
  var lapCounts: [Int] = []
  var lapCount: Int = 0
//UI업데이트 콜백
  var onTimeUpdate: ((String) -> Void)?
  var onLapUpdate: ((String) -> Void)?

  func didTapStartStopButton() {
    switch self.watchStatus {
    case .stop://초기에 시작버튼을 누를경우
      startTimer()// 타이머 시작
    case .start:// 시작상태에서 정지버튼을 누를경우
      stopTimer()
    case .pause:// 정지상태에서 시작버튼을 누를경우
      restartTimer()
    }
  }
  
  func didTapLapResetButton() {
    switch self.watchStatus {
    case .stop: break
    case .start: //타이머가 구동되는동안 랩버튼을 누를경우
      self.saveLapRecord()
    case .pause: // 타이머가 멈춰있는동안 재시작을 누를경우
      self.resetAllData()
    }
  }
  
  private func startTimer() {
    self.watchStatus = .start //상태가 시작으로 바뀌고
    startTime = Date()//시작한 시점의 시간이 startTime에 기록
    stopWatchTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true) // 타이머 돌아감
    RunLoop.current.add(stopWatchTimer!, forMode: .common)
    self.lapStartTime = Date()
    startLapTimer()
  }
  
  private func stopTimer() {
    self.watchStatus = .pause// 상태를 중지로 바꾸고
    stopWatchTimer?.invalidate()//타이머를 정지시킴
    lapTimer?.invalidate()
    stopWatchTimer = nil
    lapTimer = nil
  }
  
  private func restartTimer() {
    self.watchStatus = .start //상태를 중지로 바꾸고
    startTime = Date().addingTimeInterval(-elapsedTime) //현재시간에서 경과시간만큼을 뺀것을 시작시점
    self.stopWatchTimer = Timer(timeInterval: 0.01, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    RunLoop.current.add(stopWatchTimer!, forMode: .common)
    
    lapStartTime = Date().addingTimeInterval(-lapElapsedTime)
    startLapTimer()
  }
  
  private func saveLapRecord() {
      if let lapStartTime = self.lapStartTime {
        lapElapsedTime = Date().timeIntervalSince(lapStartTime)
        let lapTimeString = timeToString(from: lapElapsedTime)
        recordList.insert(lapTimeString, at: 0)
        lapCount += 1
        lapCounts.insert(lapCount, at: 0)
        onLapUpdate?(lapTimeString)
      }
    self.lapStartTime = Date()
    startLapTimer()
  }
  private func startLapTimer() {
    lapTimer?.invalidate()
    lapTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateLapTime), userInfo: nil, repeats: true)
    RunLoop.current.add(lapTimer!, forMode: .common)
  }
  private func resetAllData() {
    stopTimer()
    self.watchStatus = .stop
    elapsedTime = 0
    lapElapsedTime = 0
    recordList.removeAll()
    lapCounts.removeAll()
    lapCount = 0
    onTimeUpdate?("00:00.00")
    onLapUpdate?("00:00.00")
  }

  @objc func updateTime() {
    guard let startTime = self.startTime else { return }
    self.elapsedTime = Date().timeIntervalSince(startTime)// 시작된 시점으로 부터 의 경과시간만큼이 저장됨
    let timeString = timeToString(from: self.elapsedTime)
    onTimeUpdate?(timeString)
  }
  @objc func updateLapTime() {
    guard let lapStartTime = self.lapStartTime else { return }
    self.lapElapsedTime = Date().timeIntervalSince(lapStartTime)
    let lapTimeString = timeToString(from: lapElapsedTime)
    onLapUpdate?(lapTimeString)
  }
  
  private func timeToString(from timeInterval: TimeInterval) -> String {
    let minutes = Int(timeInterval) / 60 % 60
    let seconds = Int(timeInterval) % 60
    let milliseconds = Int(timeInterval * 100) % 100
    return String(format: "%02d:%02d.%02d", minutes, seconds, milliseconds)
  }
  
}
