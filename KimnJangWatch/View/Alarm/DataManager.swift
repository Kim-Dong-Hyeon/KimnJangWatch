//
//  DataManager.swift
//  KimnJangWatch
//
//  Created by 김윤홍 on 8/19/24.
//

import CoreData
import UIKit

class DataManager {
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

  func createTime(id: UUID, hour: String, minute: String, repeatDays: [Int], message: String, isOn: Bool, repeatAlarm: Bool, alarmSound: String) {
    let newTime = Time(context: context)
    newTime.id = id
    newTime.hour = hour
    newTime.minute = minute
    newTime.repeatDays = repeatDays
    newTime.message = message
    newTime.isOn = isOn
    newTime.repeatAlarm = repeatAlarm
    newTime.alarmSound = alarmSound  // 새로운 속성으로 추가된 alarmSound를 저장
    
    saveContext()
  }

  func readCoreData<T: NSManagedObject>(entityType: T.Type) -> [T] {
    let fetchRequest = NSFetchRequest<T>(entityName: String(describing: entityType))
    
    do {
      let results = try context.fetch(fetchRequest)
      return results
    } catch {
      print("Failed to fetch data: \(error)")
      return []
    }
  }

  func deleteTime(id: UUID) {
    let fetchRequest: NSFetchRequest<Time> = Time.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
    
    do {
      let times = try context.fetch(fetchRequest)
      if let timeToDelete = times.first {
        context.delete(timeToDelete)
        saveContext()
      }
    } catch {
      print("Failed to delete data: \(error)")
    }
  }
  
  func saveContext() {
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        print("Failed to save data: \(error)")
      }
    }
  }
  
  func updateAlarmStatus(id: UUID, isOn: Bool) {
    let fetchRequest: NSFetchRequest<Time> = Time.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
    
    do {
      let results = try context.fetch(fetchRequest)
      if let timeEntity = results.first {
        timeEntity.isOn = isOn
        try context.save()
      }
    } catch {
      print("Failed to update alarm status: \(error)")
    }
  }
  
  func readUserDefault(key: String) -> [Int]? {
    return UserDefaults.standard.object(forKey: key) as? [Int]
  }
  
  func deleteUserDefault(key: String) {
    UserDefaults.standard.removeObject(forKey: key)
  }
}
