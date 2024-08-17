//
//  TimerModel.swift
//  KimnJangWatch
//
//  Created by 김승희 on 8/16/24.
//

import Foundation

import RxCocoa
import RxSwift

struct TimerModel {
  let id: UUID
  let remainingTime: BehaviorRelay<TimeInterval>
  let isRunning: BehaviorRelay<Bool>
  var disposeBag: DisposeBag?
}
