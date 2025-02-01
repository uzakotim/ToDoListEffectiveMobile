//
//  TaskListView.swift
//  ToDoListEffectiveMobile
//
//  Created by Timur Uzakov on 31/01/25.
//
import SwiftUI

// Представление списка задач
struct TaskList: View {
    let tasks: [Task] // Массив задач
    let onEdit: (Task) -> Void // Коллбэк для редактирования задачи
    let onDelete: (Task) -> Void // Коллбэк для удаления задачи
    let onShare: (Task) -> Void // Коллбэк для шаринга задачи
    @ObservedObject var presenter: TaskListPresenter // Презентер, управляющий данными
    @Binding var isNavigatingToTaskDetail: Bool // Флаг навигации к деталям задачи
    @Binding var selectedTask: Task // Выбранная задача
    
    var body: some View {
        List {
            ForEach(tasks) { task in
                // Определяем, является ли задача последней в списке
                let isLast = tasks.firstIndex(of: task)! == self.tasks.count - 1
                // Отображение отдельной задачи
                ListItemView(task: task, isLast: isLast)
                    // Определение области кликабельности
                    .contentShape(Rectangle())
                    .contextMenu {
                        Button(action: { onEdit(task) }) {
                            // Кнопка редактирования
                            Label("Редактировать", systemImage: "square.and.pencil")
                        }
                        Button(action: { onShare(task) }) {
                            // Кнопка поделиться
                            Label("Поделиться", systemImage: "square.and.arrow.up")
                        }
                        Button(role: .destructive, action: { onDelete(task) }) {
                            // Кнопка удаления
                            Label("Удалить", systemImage: "trash")
                        }
                    } preview: { CustomContextMenuPreviewView(task: task) } // Превью контекстного меню
                    .listRowSeparator(.hidden) // Скрытие разделителя строк
                    .onTapGesture {
                        // Переключение состояния задачи по нажатию
                        presenter.toggleTask(task: task)
                    }
                    
                

                    
            }
            
            .onDelete { indexSet in
                for index in indexSet {
                    let taskToDelete = presenter.tasks[index]
                    // Удаление задачи
                    presenter.deleteTask(task: taskToDelete)
                }
            }
            
        }
        // Установка локали на русский язык
        .environment(\.locale, Locale(identifier: "ru"))
        // Установка стиля списка
        .listStyle(PlainListStyle())
        // Фон списка
        .background(Color(.systemBackground))
        // Навигация к деталям задачи
        .navigationDestination(isPresented: $isNavigatingToTaskDetail){
            presenter.router.navigateToTaskDetails(with: selectedTask)
        }
        // Максимальная ширина
        .frame(maxWidth: .infinity)
        // Заголовок страницы
        .navigationTitle("Задачи")
        // Загрузка данных при появлении экрана
        .onAppear {
            presenter.loadData()
        }
    }
    
}
// Главное представление списка задач
struct TaskListView: View {
    @ObservedObject var presenter: TaskListPresenter // Презентер списка задач
    @State private var isNavigatingToTaskDetail = false // Флаг навигации
    @State private var searchText: String = "" // Текст поиска
    @State private var selectedTask: Task = Task(id: 0, title: "", description: "", isCompleted: false) // Выбранная задача
      
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
                // Нижняя панель инструментов
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
// Превью представления списка задач
struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        let interactor = TaskListInteractor()
        let router = TaskListRouter()
        let presenter = TaskListPresenter(interactor: interactor, router: router)

        return TaskListView(presenter: presenter)
    }
}
