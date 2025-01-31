//
//  TaskListRouter.swift
//  ToDoListEffectiveMobile
//
//  Created by Timur Uzakov on 31/01/25.
//
import SwiftUI

protocol TaskListRouterProtocol {
    func navigateToTaskDetails(with task: Task) -> TaskDetailView
    func createMainScreen() -> TaskListView
}

class TaskListRouter: TaskListRouterProtocol {
    func navigateToTaskDetails(with task: Task) -> TaskDetailView {
        let interactor = TaskDetailInteractor(task: task)
        let router = TaskDetailRouter()
        let presenter = TaskDetailPresenter(interactor: interactor, router: router)
        let view = TaskDetailView(presenter: presenter, task: task)
        
        return view
    }
    
    func createMainScreen() -> TaskListView {
        let interactor = TaskListInteractor()
        let presenter = TaskListPresenter(interactor: interactor, router: self)
        let view = TaskListView(presenter: presenter)
        return view
    }
}
