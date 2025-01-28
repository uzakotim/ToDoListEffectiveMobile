import SwiftUI

protocol TaskListRouterProtocol {
    func navigateToAddTask()
}

class TaskListRouter: TaskListRouterProtocol {  // To hold a reference to the current view controller
    func navigateToAddTask() {
        // Implement the navigation logic to add a task screen
    }
    
    func createMainScreen() -> some View {
        let interactor = TaskListInteractor()
        let presenter = TaskListPresenter(interactor: interactor, router: self)
        let view = TaskListView(presenter: presenter)
        return view
    }
}
