import Foundation
import CoreData

protocol TaskListInteractorProtocol {
    func fetchTasks(completion: @escaping (Result<[Task], Error>) -> Void)
    func saveTask(_ task: Task, completion: @escaping () -> Void)
    func deleteTask(_ task: Task, completion: @escaping () -> Void)
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
                    let decodedResponse = try JSONDecoder().decode([Task].self, from: data)
                    completion(.success(decodedResponse))
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

    func deleteTask(_ task: Task, completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).async {
            // Удаление из CoreData
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}
