//
//  StopWatchViewModel.swift
//  KimnJangWatch
//
//  Created by bloom on 8/13/24.
//

import Foundation
enum WatchStatus {
  case start
  case stop
}

class StopWatchViewModel {
  var watchStatus: WatchStatus = .start
  var timer: Timer?
  var startTime = Date()
///화면이 꺼지거나 앱이 꺼졌을때 시간을 담을 변수
  var elapsedTime: TimeInterval = 0
  var recordList: [String] = []

  var onTimeUpdate: ((String) -> Void)?
  
  init() {
    
  }
  
  func didTapStartButton() {
    switch self.watchStatus {
    case .start:
      self.watchStatus = .stop
      startTime = Date() - elapsedTime
      self.timer = Timer.scheduledTimer(timeInterval: 0.001,
                                        target: self,
                                        selector: #selector(timeUp),
                                        userInfo: nil,
                                        repeats: true)
    case .stop:


      print(recordList.index(recordList.endIndex, offsetBy: -1))
    }
  }
  
  @objc private func timeUp(){ //타임의 계산 작업
    let time: Double = 60
    let timeInterval = Date().timeIntervalSince(self.startTime)
    let times = [(fmod((timeInterval/time/time),12)),
                 (fmod((timeInterval/time),time)),
                 (fmod((timeInterval), time)),
                 ( (timeInterval - floor(timeInterval)) * 1000 )].map{Int($0)}
    let hourString = String(format: "%02d", times[0])
    let minuteString = String(format: "%02d", times[1])
    let secondString = String(format: "%02d", times[2])
    let milliString = String(format: "%02d", times[3])
  }
  @objc func didTapResetButton(){
    
  }

  
  
  
}

extension StopWatchViewModel {
///앱밖을 나가게 되었을때 현재시간을 저장하고 중단상태일때는 타이머를 멈춤
  @objc private func appWillEnterBackground() {
    UserDefaults.standard.set(Date(), forKey: "savedStartTime")
    UserDefaults.standard.set(elapsedTime, forKey: "savedElapsedTime")
    if watchStatus == .stop {
      timer?.invalidate()
    }
  }
  
  
}
