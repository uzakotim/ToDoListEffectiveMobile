//
//  TaskListPresenter.swift
//  ToDoListEffectiveMobile
//
//  Created by Timur Uzakov on 31/01/25.
//
import SwiftUI
import CoreData

// Презентер для управления списком задач
class TaskListPresenter: ObservableObject {

    
    @Published var tasks: [Task] = [] // Все задачи
    @Published var filteredTasks: [Task] = [] // Отфильтрованные задачи

    private let interactor: TaskListInteractorProtocol // Интерфейс взаимодействия с данными
    public let router: TaskListRouterProtocol // Интерфейс для навигации

    init(interactor: TaskListInteractor, router: TaskListRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    func isFirstRun() -> Bool {
        // Проверка на первый запуск
        let hasRunBefore = UserDefaults.standard.bool(forKey: "hasRunBefore")
        
        if !hasRunBefore {
            UserDefaults.standard.set(true, forKey: "hasRunBefore")
            return true
        }
        return false
    }
    
    func loadData() {
        // Основная логика при запуске
        if isFirstRun(){
            self.loadTasks()
        }
        else{
            self.loadTasksFromCoreData()
        }
    }
    
    func loadTasks() {
        // Загрузка задач из API
        interactor.fetchTasks { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let tasks):
                    // Сортировка по id для dummy todo листа
                    let sortedTasks = tasks.sorted { $0.id > $1.id }
                    self?.tasks = sortedTasks
                    self?.filteredTasks = sortedTasks
                    self?.saveTasks(tasks: sortedTasks)
                case .failure(let error):
                    print("Ошибка загрузки: \(error)")
                }
            }
        }
    }
    
    func saveTasks(tasks: [Task]) {
        // Сохранение задач в CoreData
        let context = PersistenceController.shared.container.newBackgroundContext()
        context.perform {
            for itemName in tasks {
                let item = CDTask(context: context)
                item.id = Int32(itemName.id)
                item.dateCreated = itemName.dateCreated
                item.title = itemName.title
                item.descriptionData = itemName.descriptionData
                item.isCompleted = itemName.isCompleted
            }
            do {
                try context.save()
                print("Array saved successfully")
            } catch {
                print("Failed to save array: \(error.localizedDescription)")
            }
        }
    }
    func loadTasksFromCoreData() {
        // Загрузка задач из CoreData
        let context = PersistenceController.shared.container.newBackgroundContext()
        context.perform {
            let fetchRequest: NSFetchRequest<CDTask> = CDTask.fetchRequest()
            do {
                let taskEntities = try context.fetch(fetchRequest)
                let result = taskEntities.map { taskEntity in
                    Task(
                        id: Int(taskEntity.id),
                        title: taskEntity.title ?? "",
                        description: taskEntity.descriptionData ?? "",
                        dateCreated: taskEntity.dateCreated ?? Date(),
                        isCompleted: taskEntity.isCompleted
                    )
                }
                DispatchQueue.main.async {
                    // Сортировка по дате для последующих запусков приложения
                    self.tasks = result.sorted { $0.dateCreated > $1.dateCreated }
                    self.filteredTasks = self.tasks
                    print("Successfully loaded tasks from CoreData")
                }
            } catch {
                print("Error loading from CoreData: \(error)")
            }
        }
    }

    func openTaskDetails(for task: Task) {
        // Открытие экрана деталей задачи
        _ = router.navigateToTaskDetails(with: task)
    }

    func toggleTask(task: Task) {
        // Функция меняющее состояние (выполнена или нет) задачи
        let context = PersistenceController.shared.container.newBackgroundContext()
        context.perform {
            let fetchRequest: NSFetchRequest<CDTask> = CDTask.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", task.id)
            
            do {
                let taskEntities = try context.fetch(fetchRequest)
                if let taskEntity = taskEntities.first {
                    taskEntity.isCompleted.toggle()
                    try context.save()
                    print("Task completion toggled successfully in Core Data")

                    DispatchQueue.main.async {
                        if let index = self.tasks.firstIndex(where: { $0.id == task.id }) {
                            self.tasks[index].isCompleted.toggle()
                        }
                        self.filteredTasks = self.tasks
                    }
                }
            } catch {
                print("Failed to toggle task: \(error.localizedDescription)")
            }
        }
    }

    
    func deleteTask(task: Task) {
        let context = PersistenceController.shared.container.newBackgroundContext()
        context.perform {
            let fetchRequest: NSFetchRequest<CDTask> = CDTask.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", task.id)
            
            do {
                let taskEntities = try context.fetch(fetchRequest)
                if let taskEntity = taskEntities.first {
                    context.delete(taskEntity)
                    try context.save()
                    print("Task deleted successfully")

                    DispatchQueue.main.async {
                        self.tasks.removeAll { $0.id == task.id }
                        self.filteredTasks = self.tasks
                    }
                }
            } catch {
                print("Failed to delete task: \(error.localizedDescription)")
            }
        }
    }
    func searchTasks(query: String) {
        // Логика поиска задачи
        DispatchQueue.global(qos: .userInitiated).async {
            let filteredResults: [Task]
            
            if query.isEmpty {
                filteredResults = self.tasks
            } else {
                filteredResults = self.tasks.filter { $0.title.lowercased().contains(query.lowercased()) }
            }
            
            DispatchQueue.main.async {
                self.filteredTasks = filteredResults
            }
        }
    }
}

