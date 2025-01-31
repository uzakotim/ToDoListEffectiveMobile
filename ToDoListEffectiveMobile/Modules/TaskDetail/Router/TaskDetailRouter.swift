//
//  TaskDetailRouter.swift
//  ToDoListEffectiveMobile
//
//  Created by Timur Uzakov on 29/01/25.
//

import SwiftUI

protocol TaskDetailRouterProtocol {
    func navigateBack() -> any View
    func createModule(task: Task) -> TaskDetailView
}

class TaskDetailRouter: TaskDetailRouterProtocol{
    func navigateBack() -> any View {
        // Перейти в главный лист
        let interactor = TaskListInteractor()
        let router = TaskListRouter()
        let presenter = TaskListPresenter(interactor: interactor, router: router)
        let view = TaskListView(presenter: presenter)
        return view
    }

    func createModule(task: Task) -> TaskDetailView {
        // Создать экран задачи, подробный
        let interactor = TaskDetailInteractor(task: task)
        let router = TaskDetailRouter()
        let presenter = TaskDetailPresenter(interactor: interactor, router: router)
        let view = TaskDetailView(presenter: presenter, task: task)
        return view
    }
}
