//
//  TaskDetailInteractor.swift
//  ToDoListEffectiveMobile
//
//  Created by Timur Uzakov on 29/01/25.
//

import Foundation

// Протокол TaskDetailInteractorProtocol определяет интерфейс для получения информации о задаче
protocol TaskDetailInteractorProtocol {
    var task: Task { get } // Свойство, представляющее текущую задачу
}

class TaskDetailInteractor: TaskDetailInteractorProtocol {
    let task: Task

    init(task: Task) {
        self.task = task
    }
    func fetchTaskDetails() -> Task {
        return task
    }
}

