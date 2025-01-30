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
}
