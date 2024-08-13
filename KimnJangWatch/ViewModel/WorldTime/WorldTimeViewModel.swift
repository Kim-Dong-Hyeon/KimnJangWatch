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

//  var idArray = [String]()
  var ids = BehaviorRelay(value: [String]())
  
  init() {
    getIdArray()
  }
  
  func getIdArray() {
    guard let id = UserDefaults.standard.array(forKey: "city") as? [String] else { return }
    ids.accept(id)
  }
  
}
