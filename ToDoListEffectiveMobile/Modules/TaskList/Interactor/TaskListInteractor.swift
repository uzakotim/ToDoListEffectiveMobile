import Foundation
import CoreData

protocol TaskListInteractorProtocol {
    func fetchTasks(completion: @escaping (Result<[Task], Error>) -> Void)
    func saveTask(_ task: Task, completion: @escaping () -> Void)
    func deleteTask(_ task: Task, completion: @escaping () -> Void)
    func saveTasksToCoreData(_ tasks: [Task], completion: @escaping () -> Void) 
}

class TaskListInteractor: TaskListInteractorProtocol {
    
    
    private let context = PersistenceController.shared.container.viewContext
    
    func fetchTasks(completion: @escaping (Result<[Task], Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let url = URL(string: "https://dummyjson.com/todos") else { return }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Нет данных"])))
                    return
                }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(TodosResponse.self, from: data)
                    completion(.success(decodedResponse.todos))
                    print("Success")
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
    }
        
    func saveTask(_ task: Task, completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).async {
            // Сохранение в CoreData
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    func saveTasksToCoreData(_ tasks: [Task], completion: @escaping () -> Void) {
        let context = PersistenceController.shared.container.newBackgroundContext()
        
        context.perform {
            for task in tasks {
                let taskEntity = CDTask(context: context)
                taskEntity.id = Int32(task.id)
                taskEntity.title = task.title
                taskEntity.descriptionData = task.descriptionData
                taskEntity.dateCreated = task.dateCreated
                taskEntity.isCompleted = task.isCompleted
            }
            
            do {
                try context.save()
                print("Tasks successfully saved to Core Data.")
                completion() // Call completion after saving
            } catch {
                print("Failed to save tasks to Core Data: \(error)")
                completion() // Call completion even if there's an error
            }
        }
    }
    func fetchTasksFromCoreData(completion: @escaping ([Task]) -> Void) {
        let context = PersistenceController.shared.container.viewContext
        
        print("Fetching tasks from Core Data...")
        let fetchRequest: NSFetchRequest<CDTask> = CDTask.fetchRequest()
        
        context.perform {
            do {
                let taskEntities = try context.fetch(fetchRequest) // Fetch using backgroundContext
                print(taskEntities.count)
            } catch {
                print("Failed to fetch tasks: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion([]) // Return an empty array in case of failure
                }
            }
        }
    }
    func deleteTask(_ task: Task, completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).async {
            // Удаление из CoreData
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}
