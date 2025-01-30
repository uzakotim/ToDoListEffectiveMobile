//
//  TaskDataToDoEntity+CoreDataProperties.swift
//  ToDoListEffectiveMobile
//
//  Created by Timur Uzakov on 30/01/25.
//
//

import Foundation
import CoreData


extension TaskDataToDoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskDataToDoEntity> {
        return NSFetchRequest<TaskDataToDoEntity>(entityName: "TaskDataToDoEntity")
    }

    @NSManaged public var id: Int32
    @NSManaged public var title: String?
    @NSManaged public var descriptionData: String?
    @NSManaged public var dateCreated: Date?
    @NSManaged public var isCompleted: Bool

}

extension TaskDataToDoEntity : Identifiable {

}
