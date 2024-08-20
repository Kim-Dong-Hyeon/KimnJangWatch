//
//  AlarmModel.swift
//  KimnJangWatch
//
//  Created by 김윤홍 on 8/19/24.
//

import Foundation

struct Alarm {
  var days: [String]
  var time: String
}

struct AddAlarm {
  let songs: [(displayName: String, fileName: String)] = [
    (displayName: "기본음", fileName: "default"),
    (displayName: "후무스", fileName: "hummus"),
    (displayName: "노크 브러시", fileName: "knock_brush"),
    (displayName: "Boop", fileName: "boop"),
    (displayName: "강아지", fileName: "dog"),
    (displayName: "고양이", fileName: "cat"),
    (displayName: "사이렌", fileName: "siren")
  ]
  let day = ["일요일마다", "월요일마다", "화요일마다", "수요일마다", "목요일마다", "금요일마다", "토요일마다"]
}
