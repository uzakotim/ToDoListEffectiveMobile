import SwiftUI

class TaskListPresenter: ObservableObject {
    @Published var tasks: [Task] = []
    @Published var filteredTasks: [Task] = []

    private let interactor: TaskListInteractorProtocol
    private let router: TaskListRouterProtocol

    init(interactor: TaskListInteractorProtocol, router: TaskListRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }

    func loadTasks() {
        interactor.fetchTasks { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let tasks):
                    self?.tasks = tasks
                    self?.filteredTasks = tasks
                case .failure(let error):
                    print("Ошибка загрузки: \(error)")
                }
            }
        }
    }

    func addNewTask() {
        router.navigateToAddTask()
    }

    func deleteTask(at offsets: IndexSet) {
        offsets.forEach { index in
            let task = tasks[index]
            interactor.deleteTask(task) { [weak self] in
                self?.loadTasks()
            }
        }
    }

    func searchTasks(query: String) {
        if query.isEmpty {
            filteredTasks = tasks
        } else {
            filteredTasks = tasks.filter { $0.title.lowercased().contains(query.lowercased()) }
        }
    }
}