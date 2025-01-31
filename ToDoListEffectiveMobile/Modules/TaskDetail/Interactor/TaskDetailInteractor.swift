//
//  TaskDetailInteractor.swift
//  ToDoListEffectiveMobile
//
//  Created by Timur Uzakov on 29/01/25.
//

import Foundation

protocol TaskDetailInteractorProtocol {
    var task: Task { get }
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
