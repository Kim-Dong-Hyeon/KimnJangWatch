//
//  TimeZoneModalViewModel.swift
//  KimnJangWatch
//
//  Created by Soo Jang on 8/13/24.
//

import Foundation

import RxSwift

class TimeZoneModalViewModel {
  var identifiers = [(eng: String, kor: String)]()

  init() {
    getAllTimeZone()
  }

  func getAllTimeZone() {
    let engIdentifiers = TimeZone.knownTimeZoneIdentifiers
    let korIdentifiers = engIdentifiers.compactMap {
      TimeZone(identifier: $0)?.localizedName(for: .shortGeneric ,locale: Locale(identifier: "ko_KR"))
    }

    identifiers = engIdentifiers.enumerated().map { index, eng -> (eng: String, kor: String) in
      return (eng: eng, kor: korIdentifiers[index])
    }.sorted { $0.kor < $1.kor }
    identifiers.remove(at: 0) // GMT 삭제
  }
  
  func addTimeZone(id: String) {
    if UserDefaults.standard.array(forKey: "city") == nil {
      UserDefaults.standard.set([id], forKey: "city")
    } else {
      var currentTimeZone = UserDefaults.standard.array(forKey: "city")
      currentTimeZone?.append(id)
      UserDefaults.standard.set(currentTimeZone, forKey: "city")
    }
  }
}
