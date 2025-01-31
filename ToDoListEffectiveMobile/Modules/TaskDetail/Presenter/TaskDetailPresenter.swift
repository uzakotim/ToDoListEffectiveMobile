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
    
    func updateTask(task: Task, title: String, descriptionData: String) {
        let context = PersistenceController.shared.container.newBackgroundContext()
        context.perform {
            // Проверка на изменение оглавления и названия
            var previousDate = task.dateCreated
            if (task.title != title) || (task.descriptionData != descriptionData) {
                // Поменять дату если что-то изменилось
                previousDate = Date()
            }
            
            // Найти задачу по id
            let fetchRequest: NSFetchRequest<CDTask> = CDTask.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", task.id)

            do {
                let taskEntities = try context.fetch(fetchRequest)
                if let taskEntity = taskEntities.first {
                    // Обновление задачи в Core Data
                    taskEntity.dateCreated = previousDate
                    taskEntity.title = title
                    taskEntity.descriptionData = descriptionData
                    try context.save()
                    print("Task updated successfully in Core Data")
                    
                    let updatedTask = Task(id: task.id, title: title, description: descriptionData, dateCreated: previousDate, isCompleted: task.isCompleted)

                    // Обновление задачи в UI
                    DispatchQueue.main.async {
                        if let index = self.tasks.firstIndex(where: { $0.id == task.id }) {
                            self.tasks[index] = updatedTask
                        }
                        self.filteredTasks = self.tasks
                    }
                }
            } catch {
                print("Failed to update task: \(error.localizedDescription)")
            }
        }
    }
    
    func addNewTask(title: String, descriptionData: String) {
        let context = PersistenceController.shared.container.newBackgroundContext()
        context.perform {
            let fetchRequest: NSFetchRequest<CDTask> = CDTask.fetchRequest()
            
            do {
                let taskEntities = try context.fetch(fetchRequest)
                // Найти уникальный id, т.е. свободный на данный момент
                let existingIDs = taskEntities.map { Int($0.id) }
                
                var newID = 1
                while existingIDs.contains(newID) {
                    newID += 1
                }
                
                // Обновление задачи
                let newTask = Task(id: newID, title: title, description: descriptionData, dateCreated: Date(), isCompleted: false)
                
                let taskEntity = CDTask(context: context)
                taskEntity.id = Int32(newTask.id)
                taskEntity.dateCreated = newTask.dateCreated
                taskEntity.title = newTask.title
                taskEntity.descriptionData = newTask.descriptionData
                taskEntity.isCompleted = newTask.isCompleted
                
                try context.save()
                print("New task added successfully to Core Data")
                // Обновление UI
                DispatchQueue.main.async {
                    self.tasks.insert(newTask, at: 0)
                    self.filteredTasks = self.tasks
                }
            } catch {
                print("Failed to fetch tasks or add new task: \(error.localizedDescription)")
            }
        }
    }
}
