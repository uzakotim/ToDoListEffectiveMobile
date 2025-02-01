//
//  TaskListInteractor.swift
//  ToDoListEffectiveMobile
//
//  Created by Timur Uzakov on 31/01/25.
//

import Foundation
import CoreData

protocol TaskListInteractorProtocol {
    func fetchTasks(completion: @escaping (Result<[Task], Error>) -> Void)
}

class TaskListInteractor: TaskListInteractorProtocol {
    
    
    private let context = PersistenceController.shared.container.viewContext
    
    func fetchTasks(completion: @escaping (Result<[Task], Error>) -> Void) {
        // Загрузка задач из внешнего источника dummy JSON API
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
}
