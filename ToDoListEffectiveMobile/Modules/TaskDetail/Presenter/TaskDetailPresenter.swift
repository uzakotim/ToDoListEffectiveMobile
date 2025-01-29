//
//  TaskDetailPresenter.swift
//  ToDoListEffectiveMobile
//
//  Created by Timur Uzakov on 29/01/25.
//

import SwiftUI

class TaskDetailPresenter: ObservableObject {
    @Published var task: Task
    private let interactor: TaskDetailInteractorProtocol
    private let router: TaskDetailRouterProtocol

    init(interactor: TaskDetailInteractor, router: TaskDetailRouter) {
        self.interactor = interactor
        self.task = interactor.task
        self.router = router
    }

    func goBack() {
        router.navigateBack()
    }
}
