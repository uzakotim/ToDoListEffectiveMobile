//
//  ListItemView.swift
//  ToDoListEffectiveMobile
//
//  Created by Timur Uzakov on 29/01/25.
//
import SwiftUI

// Представление элемента списка задач
struct ListItemView: View {
    var task: Task // Задача, отображаемая в данном элементе списка
    let isLast: Bool // Флаг, указывающий, является ли элемент последним в списке
    
    var body: some View {
        Section{
            VStack(alignment: .leading, spacing: 0){
                VStack(alignment: .leading, spacing: 0) {
                    HStack{
                        Image(systemName: task.isCompleted ? "checkmark.circle" : "circle") // Иконка статуса задачи
                            .foregroundColor(.yellow) // Цвет иконки
                            .imageScale(.large) // Размер иконки
                        Text(task.title) // Заголовок задачи
                            .font(.headline) // Стиль шрифта заголовка
                            .strikethrough(task.isCompleted, color: Color(UIColor.placeholderText)) // Перечёркивание, если выполнено
                            .foregroundColor(task.isCompleted ? Color(UIColor.placeholderText) : .primary) // Цвет текста в зависимости от состояния
                            .lineLimit(nil) // Без ограничения количества строк
                            .fixedSize(horizontal: false, vertical: true) // Авторазмер по вертикали
                    }
                    HStack{
                        Image(systemName: "checkmark.circle") // Пустая невидимая иконка для выравнивания
                            .imageScale(.large)
                            .opacity(0)
                            .frame(height: 0)
                        VStack(alignment: .leading) {
                            if !task.descriptionData.isEmpty
                            {
                                Text(task.descriptionData) // Описание задачи
                                    .font(.subheadline) // Стиль шрифта описания
                                    .foregroundColor(task.isCompleted ? Color(UIColor.placeholderText) : .primary) // Цвет текста в зависимости от состояния
                                    .lineLimit(nil) // Без ограничения количества строк
                                    .fixedSize(horizontal: false, vertical: true) // Авторазмер по вертикали
                            }
                            
                            Text(task.dateCreatedFormatted) // Дата создания задачи
                                .font(.footnote) // Стиль шрифта даты
                                .foregroundColor(Color(UIColor.placeholderText)) // Цвет даты
                            
                            if task.descriptionData.isEmpty {
                                Spacer() // Добавление пустого пространства, если нет описания
                            }
                        }
                    }
                }
                if !task.descriptionData.isEmpty {
                    Spacer() // Отступ, если есть описание
                }
                if !isLast {
                    Divider() // Разделительная линия между элементами
                        .frame(height: 1) // Высота разделителя
                        .background(Color(UIColor.placeholderText)) // Цвет разделителя
                        .padding(0) // Убираем дополнительные отступы
                }
            }
        }
    }
}
// Превью для отображения в Xcode
struct ListItemView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleTask = Task(
            id: 1,
            title: "Workout", // Пример названия задачи
            description: "", // Описание отсутствует
            dateCreated: Date(), // Текущая дата создания
            isCompleted: false // Задача не завершена
        )


        return ListItemView(task: sampleTask, isLast: false)  // Пример отображения задачи
    }
}

