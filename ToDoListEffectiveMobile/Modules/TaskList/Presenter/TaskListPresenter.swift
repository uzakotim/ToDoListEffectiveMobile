import SwiftUI
import CoreData

class TaskListPresenter: ObservableObject {
    @Published var tasks: [Task] = []
    @Published var filteredTasks: [Task] = []

    private let interactor: TaskListInteractorProtocol
    public let router: TaskListRouterProtocol

    init(interactor: TaskListInteractor, router: TaskListRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    func isFirstRun() -> Bool {
        let hasRunBefore = UserDefaults.standard.bool(forKey: "hasRunBefore")
        
        if !hasRunBefore {
            UserDefaults.standard.set(true, forKey: "hasRunBefore")
            return true
        }
        return false
    }
    
    func loadData() {
        if isFirstRun(){
            self.loadTasks()
        }
        else{
            self.loadTasksFromCoreData()
        }
    }
    
    func loadTasks() {
        interactor.fetchTasks { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let tasks):
                    self?.tasks = tasks
                    self?.filteredTasks = tasks
                    self?.saveTasks(tasks: tasks)
                case .failure(let error):
                    print("Ошибка загрузки: \(error)")
                }
            }
        }
    }
    
    func saveTasks(tasks: [Task]) {
        let context = PersistenceController.shared.container.viewContext
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
    func loadTasksFromCoreData() {
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<CDTask> = CDTask.fetchRequest()
        do {
            let taskEntities = try context.fetch(fetchRequest)
            var result = [] as [Task]  // Declare result outside the loop
            for taskEntity in taskEntities {
                let task = Task(
                    id: Int(taskEntity.id),
                    title: taskEntity.title ?? "",
                    description: taskEntity.descriptionData ?? "",
                    dateCreated: taskEntity.dateCreated ?? Date(),
                    isCompleted: taskEntity.isCompleted
                )
                result.append(task)  // Append each task to the result array
            }
            self.tasks = result  // Assign the full result array to tasks
            self.filteredTasks = self.tasks  // Update filtered tasks as well
        } catch {
            print("Ошибка загрузки из CoreData: \(error)")
        }
        print("Successfully loaded tasks from CoreData")
    }

    func addNewTask() {
        router.navigateToAddTask()
    }
    func openTaskDetails(for task: Task) {
        _ = router.navigateToTaskDetails(with: task)
    }

    func toggleTask(task: Task){
        let context = PersistenceController.shared.container.viewContext
        
        // Create a fetch request to find the task by its ID
        let fetchRequest: NSFetchRequest<CDTask> = CDTask.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", task.id)  // Assuming 'id' is unique
        
        do {
            let taskEntities = try context.fetch(fetchRequest)
            
            // Assuming the task exists, delete it
            if let taskEntity = taskEntities.first {
                taskEntity.isCompleted.toggle()
                try context.save()  // Save the context to persist the deletion
                print("Task completion toggled successfully in Core Data")
            }
        } catch {
            print("Failed to delete task: \(error.localizedDescription)")
        }
        // find task in tasks
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
        }
        self.filteredTasks = self.tasks
    }
    func deleteTask(task: Task) {
        let context = PersistenceController.shared.container.viewContext
        
        // Create a fetch request to find the task by its ID
        let fetchRequest: NSFetchRequest<CDTask> = CDTask.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", task.id)  // Assuming 'id' is unique
        
        do {
            let taskEntities = try context.fetch(fetchRequest)
            
            // Assuming the task exists, delete it
            if let taskEntity = taskEntities.first {
                context.delete(taskEntity)  // Delete the fetched object
                try context.save()  // Save the context to persist the deletion
                print("Task deleted successfully")
            }
        } catch {
            print("Failed to delete task: \(error.localizedDescription)")
        }
        self.tasks.removeAll() { $0.id == task.id }
        self.filteredTasks = self.tasks
    }
    
    func searchTasks(query: String) {
        if query.isEmpty {
            filteredTasks = tasks
        } else {
            filteredTasks = tasks.filter { $0.title.lowercased().contains(query.lowercased()) }
        }
    }
}

