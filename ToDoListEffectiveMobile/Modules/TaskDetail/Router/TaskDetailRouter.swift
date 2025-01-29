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
        let interactor = TaskListInteractor()
        let router = TaskListRouter()// A new interactor for TaskList
        let presenter = TaskListPresenter(interactor: interactor, router: router)
        let view = TaskListView(presenter: presenter)
        return view
    }

    func createModule(task: Task) -> TaskDetailView {
        let interactor = TaskDetailInteractor(task: task)
        let router = TaskDetailRouter()// A new interactor for TaskList
        let presenter = TaskDetailPresenter(interactor: interactor, router: router)
        let view = TaskDetailView(presenter: presenter, task: task)
        return view
    }
}
