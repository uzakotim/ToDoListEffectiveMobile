//
//  CustomContextMenu.swift
//  ToDoListEffectiveMobile
//
//  Created by Timur Uzakov on 31/01/25.
//
import SwiftUI

// Представление предпросмотра контекстного меню для задачи
struct CustomContextMenuPreviewView: View {
    let task: Task // Задача, информация о которой будет отображаться

    var body: some View {
        HStack{
            VStack(alignment: .leading, spacing: 2) {
                Text(task.title) // Заголовок задачи
                    .font(.headline) // Стиль шрифта заголовка
                    .foregroundColor(.primary) // Основной цвет текста
                    .lineLimit(nil) // Без ограничения количества строк
                    .fixedSize(horizontal: false, vertical: true) // Авторазмер по вертикали
                
                Text(task.descriptionData) // Описание задачи
                    .font(.subheadline) // Стиль шрифта описания
                    .foregroundColor(.primary) // Основной цвет текста
                    .lineLimit(nil) // Без ограничения количества строк
                    .fixedSize(horizontal: false, vertical: true) // Авторазмер по вертикали
                
                
                Text(task.dateCreatedFormatted) // Дата создания задачи
                    .font(.caption) // Стиль шрифта для даты
                    .foregroundColor(.gray) // Серый цвет для менее важной информации
            }
            .padding(24) // Внутренний отступ для содержимого
            Spacer() // Раздвижение содержимого по горизонтали
        }
        .padding(24) // Внешний отступ
        .cornerRadius(12) // Скругление углов
        .frame(minWidth: 200, maxWidth: 400) // Ограничение по ширине
    }
}
