//
//  WorldTimeViewModel.swift
//  KimnJangWatch
//
//  Created by Soo Jang on 8/12/24.
//

import Foundation

import RxCocoa
import RxSwift

class WorldTimeViewModel {
  
  private let disposeBag = DisposeBag()
  
  init() {
    getIdArray()
    updateCityFromTimeZoneList()
  }
  
  func getIdArray() {
    guard let data = UserDefaults.standard.data(forKey: "city"),
          let identifiers = try? JSONDecoder().decode([TimeZoneID].self, from: data)
    else { return }
    TimeZoneList.shared.added.accept(identifiers)
  }
  
  func updateCityFromTimeZoneList() {
    TimeZoneList.shared.added
      .subscribe(onNext: { idList in
        guard let encoded = try? JSONEncoder().encode(idList) else { return }
        UserDefaults.standard.set(encoded, forKey: "city")
      })
      .disposed(by: disposeBag)
  }
  
  func getCurrentTime(identifier: String) -> (meridiem: String,time: String) {
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(identifier: identifier)
    dateFormatter.dateFormat = "a h:mm"
    
    let dateString = dateFormatter.string(from: Date())
    let meridiem = String(dateString.split(separator: " ").first!) == "AM" ? "오전" : "오후"
    let time = String(dateString.split(separator: " ").last!)

    return (meridiem: meridiem, time: time)
  }
  
}
