//
//  CDTask+CoreDataProperties.swift
//  ToDoListEffectiveMobile
//
//  Created by Timur Uzakov on 30/01/25.
//
//

import Foundation
import CoreData


extension CDTask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDTask> {
        return NSFetchRequest<CDTask>(entityName: "CDTask")
    }

    @NSManaged public var dateCreated: Date?
    @NSManaged public var descriptionData: String?
    @NSManaged public var id: Int32
    @NSManaged public var isCompleted: Bool
    @NSManaged public var title: String?
}

extension CDTask : Identifiable {

}
