//
//  BottomToolbar.swift
//  ToDoListEffectiveMobile
//
//  Created by Timur Uzakov on 31/01/25.
//
import SwiftUI

// Нижняя панель инструментов для списка задач
struct BottomToolbar: View {
    @ObservedObject var presenter: TaskListPresenter // Презентер списка задач
    @Binding var isNavigatingToTaskDetail: Bool // Флаг навигации к экрану деталей задачи
    @Binding var selectedTask: Task // Выбранная задача
    
    let emptyTask: Task = .init(id: -1, title: "", description: "", isCompleted: false) // Пустая задача для создания новой
    var body: some View {
        ZStack{
            HStack{
                Spacer()
                // Отображение количества задач с правильным склонением слова "задача"
                Text("\(presenter.filteredTasks.count) \(pluralizeTask(count: presenter.filteredTasks.count))")
                    .font(.caption)
                    .fontWeight(.light)
                    .foregroundColor(Color(UIColor.placeholderText))
                Spacer()
            }
           
            HStack{
                Spacer()
                // Кнопка для добавления новой задачи
                Button(action: {
                    isNavigatingToTaskDetail = true // Активируем переход к экрану деталей
                    selectedTask = emptyTask // Устанавливаем пустую задачу
                }) {
                    Image(systemName: "square.and.pencil") // Иконка кнопки
                        .foregroundColor(.yellow) // Цвет иконки
                }
                .accessibilityIdentifier("square.and.pencil") // Идентификатор для UI-тестирования
            }
        }
    }
    private func pluralizeTask(count: Int) -> String {
            // Логика склонения слова "задача" в зависимости от количества
            let mod10 = count % 10
            let mod100 = count % 100

            if mod10 == 1 && mod100 != 11 {
                return "задача"
            } else if mod10 >= 2 && mod10 <= 4 && (mod100 < 10 || mod100 >= 20) {
                return "задачи"
            } else {
                return "задач"
            }
        }
}
