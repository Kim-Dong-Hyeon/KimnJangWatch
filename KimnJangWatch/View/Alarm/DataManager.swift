//
//  DataManager.swift
//  KimnJangWatch
//
//  Created by 김윤홍 on 8/19/24.
//

import UIKit
import CoreData

class DataManager {
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

  func createTime(id: UUID, hour: String, minute: String, repeatDays: [Int], message: String, isOn: Bool, repeatAlarm: Bool) {
    let newTime = Time(context: context)
    newTime.id = id
    newTime.hour = hour
    newTime.minute = minute
    newTime.repeatDays = repeatDays
    newTime.message = message
    newTime.isOn = isOn
    newTime.repeatAlarm = repeatAlarm
    
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
//
//  func updateTime(id: UUID, newHour: String, newMinute: String, newRepeatDays: [Int], newMessage: String, isOn: Bool, repeatAlarm: Bool) {
//    let fetchRequest: NSFetchRequest<Time> = Time.fetchRequest()
//    fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
//    
//    do {
//      let times = try context.fetch(fetchRequest)
//      if let timeToUpdate = times.first {
//        timeToUpdate.hour = newHour
//        timeToUpdate.minute = newMinute
//        timeToUpdate.repeatDays = newRepeatDays
//        timeToUpdate.message = newMessage
//        timeToUpdate.isOn = isOn
//        timeToUpdate.repeatAlarm = repeatAlarm
//        
//        saveContext()
//      }
//    } catch {
//      print("Failed to update data: \(error)")
//    }
//  }

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
  
  private func saveContext() {
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
