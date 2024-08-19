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
  var identifiersSearching = [TimeZoneID]()
  
  init() {
    orderKoreanIdentifiers()
  }
  
  func orderKoreanIdentifiers() {
    identifiers.sort {
      $0.kor < $1.kor
    }
  }
  
  func getTableViewItems() -> [TimeZoneID] {
    if identifiersSearching.isEmpty {
      return identifiers
    } else {
      return identifiersSearching
    }
  }
  
  func getSearchedIDs(searchText: String) {
    identifiersSearching = identifiers.filter { $0.kor.contains(searchText) }
  }
  
  func clearSearchedIDs() {
    identifiersSearching = []
  }
  
  func addTimeZone(identifier: TimeZoneID) {
    var currentList = TimeZoneList.shared.added.value
    var flag = true
    currentList.forEach {
      if $0.eng == identifier.eng {
        flag = false
        return
      }
    }
    if flag {
      currentList.append(identifier)
      TimeZoneList.shared.added.accept(currentList)
    }
  }
}
