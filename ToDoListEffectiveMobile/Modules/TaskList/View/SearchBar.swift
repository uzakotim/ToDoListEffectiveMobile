//
//  SearchBar.swift
//  ToDoListEffectiveMobile
//
//  Created by Timur Uzakov on 31/01/25.
//
import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    @ObservedObject var presenter: TaskListPresenter
    var body: some View {
        HStack {
            Spacer()
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color(UIColor.placeholderText))

            TextField("Поиск", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
                .cornerRadius(6)
                .padding(.vertical, 8)
                .padding(.horizontal, 6)
                .frame(maxWidth: .infinity)
                .onChange(of: searchText) { oldValue, newValue in
                    presenter.searchTasks(query: newValue)
                }
                .disableAutocorrection(true) 
            Spacer()
        }
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .padding(.horizontal, 16)
    }
   
}
