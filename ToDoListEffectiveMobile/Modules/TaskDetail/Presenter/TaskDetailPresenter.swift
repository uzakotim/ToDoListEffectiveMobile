//
//  TaskDetailPresenter.swift
//  ToDoListEffectiveMobile
//
//  Created by Timur Uzakov on 29/01/25.
//

import SwiftUI
import CoreData

class TaskDetailPresenter: ObservableObject {
    @Published var task: Task
    @Published var tasks: [Task] = []
    @Published var filteredTasks: [Task] = []
    
    private let interactor: TaskDetailInteractorProtocol
    private let router: TaskDetailRouterProtocol
    
    init(interactor: TaskDetailInteractor, router: TaskDetailRouter) {
        self.interactor = interactor
        self.task = interactor.task
        self.router = router
    }
    func goBack() {
//        router.navigateBack()
    }
    func updateTask(task: Task, title: String , descriptionData: String){
        let context = PersistenceController.shared.container.viewContext
        let newTask = Task(id: task.id, title: title, description: descriptionData, dateCreated: Date(), isCompleted: task.isCompleted)
        // Create a fetch request to find the task by its ID
        let fetchRequest: NSFetchRequest<CDTask> = CDTask.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", task.id)
        do {
            let taskEntities = try context.fetch(fetchRequest)
            // Assuming the task exists, delete it
            if let taskEntity = taskEntities.first {
                taskEntity.dateCreated = newTask.dateCreated
                taskEntity.title = newTask.title
                taskEntity.descriptionData = newTask.descriptionData
                try context.save()  // Save the context to persist the deletion
                print("Task updated successfully in Core Data")
            }
        } catch {
            print("Failed to update task: \(error.localizedDescription)")
        }
        // find task in tasks
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = newTask
        }
        self.filteredTasks = self.tasks
    }
    func addNewTask(title: String, descriptionData: String) {
        let context = PersistenceController.shared.container.viewContext
        
        // Fetch the maximum ID from the existing tasks
        let fetchRequest: NSFetchRequest<CDTask> = CDTask.fetchRequest()
        
        do {
            let taskEntities = try context.fetch(fetchRequest)
            let existingIDs = taskEntities.map { Int($0.id) }
            // Generate a new unique ID by finding the next available number
            var newID = 1
            while existingIDs.contains(newID) {
                newID += 1  // Increment until a unique ID is found
            }
            // Create the new task object
            let newTask = Task(id: newID, title: title, description: descriptionData, dateCreated: Date(), isCompleted: false)
            
            // Create a new CDTask object for Core Data
            let taskEntity = CDTask(context: context)
            taskEntity.id = Int32(newTask.id)  // Set the unique ID
            taskEntity.dateCreated = newTask.dateCreated
            taskEntity.title = newTask.title
            taskEntity.descriptionData = newTask.descriptionData
            taskEntity.isCompleted = newTask.isCompleted
            
            // Save the new task to Core Data
            try context.save()
            print("New task added successfully to Core Data")
            
            // Add the new task to the in-memory tasks array
            tasks.insert(newTask, at: 0)
            self.filteredTasks = self.tasks
    
        } catch {
            print("Failed to fetch tasks or add new task: \(error.localizedDescription)")
        }
    }
}
