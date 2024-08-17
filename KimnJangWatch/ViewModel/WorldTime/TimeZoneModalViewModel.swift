//
//  TimeZoneModalViewModel.swift
//  KimnJangWatch
//
//  Created by Soo Jang on 8/13/24.
//

import Foundation

import RxSwift

class TimeZoneModalViewModel {
  
  var identifiers = TimeZone.getEngKor()
  
  func addTimeZone(identifier: TimeZoneID) {
    var currentList = TimeZoneList.shared.added.value
    currentList.append(identifier)
//    currentList = currentList.reduce(into: [TimeZoneID]()) { (result, id) in
//      if !result.contains(where: ) {
//           result.append(id)
//       }
//    }
    TimeZoneList.shared.added.accept(currentList)
  }
}
