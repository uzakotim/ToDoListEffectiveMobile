//
//  SearchBar.swift
//  ToDoListEffectiveMobile
//
//  Created by Timur Uzakov on 31/01/25.
//
import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String // Связанное состояние текста поиска
    @ObservedObject var presenter: TaskListPresenter // Презентер, управляющий поиском задач
    var body: some View {
        HStack {
            Spacer() // Раздвижение элементов по краям
            Image(systemName: "magnifyingglass") // Иконка поиска
                .foregroundColor(Color(UIColor.placeholderText)) // Цвет как у placeholder-а

            TextField("Поиск", text: $searchText) // Поле ввода для поиска
                .textFieldStyle(PlainTextFieldStyle()) // Стиль текстового поля
                .cornerRadius(6) // Скругление углов
                .padding(.vertical, 8) // Внутренний отступ сверху и снизу
                .padding(.horizontal, 6) // Внутренний отступ слева и справа
                .frame(maxWidth: .infinity) // Растяжение по ширине
                .onChange(of: searchText) { oldValue, newValue in
                    presenter.searchTasks(query: newValue) // Вызов метода поиска при изменении текста
                }
                .disableAutocorrection(true) // Отключение автокоррекции
            
            Spacer() // Раздвижение элементов по краям
        }
        .background(Color(.secondarySystemBackground)) // Фон элемента
        .cornerRadius(12) // Скругление углов
        .padding(.horizontal, 16) // Внешний отступ по горизонтали
    }
   
}
