//
//  TaskListView.swift
//  ToDoListEffectiveMobile
//
//  Created by Timur Uzakov on 31/01/25.
//
import SwiftUI

struct TaskList: View {
    let tasks: [Task]
    let onEdit: (Task) -> Void
    let onDelete: (Task) -> Void
    let onShare: (Task) -> Void
    @ObservedObject var presenter: TaskListPresenter
    @Binding var isNavigatingToTaskDetail: Bool
    @Binding var selectedTask: Task
    var body: some View {
        List {
            ForEach(tasks) { task in
                let isLast = tasks.firstIndex(of: task)! == self.tasks.count - 1
                ListItemView(task: task, isLast: isLast)
                    .contentShape(Rectangle())
                    .contextMenu {
                        Button(action: { onEdit(task) }) {
                            Label("Редактировать", systemImage: "square.and.pencil")
                        }
                        Button(action: { onShare(task) }) {
                            Label("Поделиться", systemImage: "square.and.arrow.up")
                        }
                        Button(role: .destructive, action: { onDelete(task) }) {
                            Label("Удалить", systemImage: "trash")
                        }
                    } preview: { CustomContextMenuPreviewView(task: task) }
                    .listRowSeparator(.hidden)
                    .onTapGesture {
                        presenter.toggleTask(task: task)
                    }
                    
                

                    
            }
            
            .onDelete { indexSet in
                for index in indexSet {
                    let taskToDelete = presenter.tasks[index]
                    presenter.deleteTask(task: taskToDelete)
                }
            }
            
        }
       
        .environment(\.locale, Locale(identifier: "ru"))
        .listStyle(PlainListStyle())
        .background(Color(.systemBackground))
        .navigationDestination(isPresented: $isNavigatingToTaskDetail){
            presenter.router.navigateToTaskDetails(with: selectedTask)
        }
        .frame(maxWidth: .infinity)
        .navigationTitle("Задачи")
        .onAppear {
            presenter.loadData()
        }
    }
    
}

struct TaskListView: View {
    @ObservedObject var presenter: TaskListPresenter
    @State private var isNavigatingToTaskDetail = false
    @State private var searchText: String = ""
    @State private var selectedTask: Task = Task(id: 0, title: "", description: "", isCompleted: false)

    var body: some View {
        NavigationStack {
            VStack {
                // Структура основного экрана
                // Верхняя секция
                SearchBar(searchText: $searchText, presenter: presenter)
                // Основная секция
                TaskList(
                    tasks: presenter.filteredTasks,
                    onEdit: { task in
                        selectedTask = task
                        isNavigatingToTaskDetail = true
                    },
                    onDelete: presenter.deleteTask,
                    onShare: shareTask,
                    presenter: presenter,
                    isNavigatingToTaskDetail: $isNavigatingToTaskDetail,
                    selectedTask: $selectedTask
                )
            }
            .toolbar{
                // Нижняя секция
                ToolbarItem(placement: .bottomBar) {
                    BottomToolbar(presenter: presenter,
                                  isNavigatingToTaskDetail: $isNavigatingToTaskDetail,
                                  selectedTask: $selectedTask
                    )
                }
            }
            .toolbarBackground(Color(UIColor.systemBackground), for: .tabBar)
            .toolbarBackground(Color(UIColor.secondarySystemBackground), for: .automatic)
        }
        
    }
    func shareTask(_ task: Task) {
        // Фунцкия для того, чтобы поделиться задачей
        let activityVC = UIActivityViewController(activityItems:
                                                    [task.title, task.descriptionData],
                                                    applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true, completion: nil)
        }
    }
}
struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        let interactor = TaskListInteractor()
        let router = TaskListRouter()
        let presenter = TaskListPresenter(interactor: interactor, router: router)

        return TaskListView(presenter: presenter)
    }
}
