//
//  Time+CoreDataProperties.swift
//  KimnJangWatch
//
//  Created by 김윤홍 on 8/19/24.
//
//

import Foundation
import CoreData


extension Time {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Time> {
        return NSFetchRequest<Time>(entityName: "Time")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var hour: String
    @NSManaged public var minute: String
    @NSManaged public var repeatDays: [Int]
    @NSManaged public var message: String?
    @NSManaged public var repeatAlarm: Bool
    @NSManaged public var isOn: Bool
    @NSManaged public var alarmSound: String?

}

extension Time : Identifiable {

}

