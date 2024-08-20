//
//  TimeZoneList.swift
//  KimnJangWatch
//
//  Created by Soo Jang on 8/14/24.
//

import Foundation

import RxCocoa

class TimeZoneList {
  static let shared = TimeZoneList()
  
  let added = BehaviorRelay<[TimeZoneID]>(value: [TimeZoneID]())
  
  private init() {}
}
